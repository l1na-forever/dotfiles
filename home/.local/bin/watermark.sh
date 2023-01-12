#!/bin/bash
set -eo pipefail

_help() {
	cat << EOF
USAGE: $(basename $0) <input_file> <watermark_file> <output_file>

Watermarks and strips metadata from a still image using ImageMagick.
EOF
}

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
	_help
	exit 1
fi

input="$1"
watermark="$2"
output="$3"

_PADDING="25"
_SCALE="35"

composite -gravity "SouthEast" \
          -geometry "$_SCALE%x$_SCALE%+$_PADDING+$_PADDING" \
          "$watermark" "$input" "$output"
exiftool -overwrite_original_in_place -All= "$output"
