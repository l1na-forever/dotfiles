#!/bin/bash
set -eo pipefail

die() { echo "$*" 1>&2 ; exit 1; }

# external requirements:
# - jq
# - curl
# - yt-dlp
# - eyeD3

# load config variables:
# - oauth_token: can be found by inspecting your cookies for soundcloud.com
# - output_path: directory to where tracks will be archived
. $HOME/.local/state/soundclown/config

if [[ -z "$oauth_token" ]]; then
  die "'oauth_token' must be set"
fi
if [[ -z "$output_path" ]]; then
  die "'output_path' must be set"
fi

mkdir -p "$output_path"
if [[ ! -d "$output_path" ]]; then
  die "'output_path' must be a directory"
fi

oauth_token_arr=(${oauth_token//-/ })
user_id=${oauth_token_arr[2]}
if [[ -z "$user_id" ]]; then
  die "Invalid 'oauth_token'"
fi

# request a new favorites page from the soundcloud API
# $1: offset parameter, starting at '0' and set to next_href on every request
get_favorites_page() {
  always_params="client_id=lsJgglOD6pTRvsFZXQCuvvGJu6RuBqgU&limit=24&linked_partitioning=1&app_version=1705331584&app_locale=en"
  if [[ -z "$1" ]]; then
    url=$(echo "https://api-v2.soundcloud.com/users/$user_id/track_likes?&offset=0&$always_params")
  else
    url=$(echo "$1&$always_params")
  fi

  curl -s "$url" --compressed \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Language: en-US,en;q=0.5' \
  -H 'Accept-Encoding: gzip, deflate, br' \
  -H 'Referer: https://soundcloud.com/' \
  -H 'Origin: https://soundcloud.com' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-site' \
  -H "Authorization: OAuth $oauth_token" \
  -H 'Connection: keep-alive'
}

# archive a single track, based on a soundcloud's track object
# $1: single track's JSON (from .collection[i].track)
archive_track() {
  track_id=$(echo $1 | jq -r '.id')
  artwork_url=$(echo $1 | jq -r 'if (.artwork_url == "" or .artwork_url == null or .artwork_url == "null") then "" else .artwork_url end' | sed 's/-large.jpg/-t500x500.jpg/')
  permalink_url=$(echo $1 | jq -r '.permalink_url')

  artist=$(echo $1 | jq -r 'if (.user.full_name == "" or .user.full_name == null) then .user.username else .user.fullname end')
  description=$(echo $1 | jq -r '.description')
  title=$(echo $1 | jq -r '.title')

  echo "Fetching $title by $artist"

  # fetch track and artwork to temporary directory
  download_dir=$(mktemp -d)
  track_path="$download_dir/$track_id.mp3"
  yt-dlp -o "$track_path" "$permalink_url"
  if [[ -n "$artwork_url" ]]; then
    artwork_path="$download_dir/$track_id.jpg"
    curl -s -o "$artwork_path" --compressed "$artwork_url" 
  fi

  # write metadata
  eyeD3 -Q -a "$artist" -t "$title" --url-frame="WOAS:$permalink_url" "$track_path"
  if [[ -n "$description" ]]; then
    lyrics_path="$download_dir/lyrics.txt"
    echo "$description" > $lyrics_path
    eyeD3 -Q --add-lyrics "$lyrics_path" "$track_path"
  fi

  # write album art, if we saved any
  if [[ -n "$artwork_path" ]]; then
    eyeD3 -Q --add-image "$artwork_path:FRONT_COVER" "$track_path" 
  fi

  # move to output directory, clean up
  output_filename=$(track_filename "$1")
  mv "$track_path" "$output_path/$output_filename"
  rm -rf "$download_dir"
}

# generates a filename for a track
# $1: single track's JSON (from .collection[i].track)
track_filename() {
  track_id=$(echo $1 | jq -r '.id')
  artist=$(echo $1 | jq -r 'if (.user.full_name == "" or .user.full_name == null) then .user.username else .user.full_name end' | iconv -f utf-8 -t us-ascii//TRANSLIT)
  title=$(echo $1 | jq -r '.title' | iconv -f utf-8 -t us-ascii//TRANSLIT)

  echo "$artist - $title - $track_id.mp3" | sed -e 's/[^A-Za-z0-9._ \(\)-]/_/g'
}

# determines if a track has already been archived to output path
# $1: single track's JSON (from .collection[i].track)
is_track_archived() {
  filename=$(track_filename "$1")  
  track_path="$output_path/$filename"
  [[ -e $track_path ]]
}

# request favorited tracks, looping while there are more paginated results
next_href=""
while true; do
  favorites_json=$(get_favorites_page "$next_href")
  if [[ -z "$favorites_json" ]]; then
    die "Expected more results from API"
  fi
  
  # archive each item
  favorites_len=$(echo "$favorites_json" | jq -r '.collection | length')
  for (( idx = 0; idx < favorites_len; idx++ )); do
    track=$(echo "$favorites_json" | jq ".collection[$idx].track")
    if ! is_track_archived "$track"; then
      archive_track "$track"
    fi
  done

  # move needle to next page in the collection, if next_href was returned
  next_href=$(echo "$favorites_json" | jq -r '.next_href')
  if [[ -z "$next_href" || "$next_href" == "null" ]]; then
    break
  fi
done

