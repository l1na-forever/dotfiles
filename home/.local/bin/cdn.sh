#!/bin/bash
set -eo pipefail

_help() {
  cat << EOF
USAGE: $(basename $0) <file>

Uploads the given file to S3, with a random filename (preserving extension).
EOF
}

if [[ -z "$1" ]]; then
  _help
  exit 1
fi
local_path="$1"

if ! [[ -f "$local_path" ]]; then
  echo "$local_path: file does not exist"
  exit 1
fi

# Read bucket and domain from ~/.local/state/cdnsh/config
. $HOME/.local/state/cdnsh/config
# Generate a UUID filename, preserving extension
remote_filename=$(echo "$(uuidgen).${local_path##*.}")
remote_path=$(echo "s3://$bucket/$remote_filename")

# Copy file
aws s3 cp "$local_path" "$remote_path" > /dev/null

# Output a friendly link
echo "https://$domain/$remote_filename"
