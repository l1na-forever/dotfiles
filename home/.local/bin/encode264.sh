#!/bin/bash
set -eo pipefail

_help() {
	cat << EOF
USAGE: $(basename $0) <input_file> <output_file>

Encodes the given input file with a high-quality/slow libx264 preset.			
EOF
}

if [[ -z "$1" || -z "$2" ]]; then
	_help
	exit 1
fi

input="$1"
output="$2"

ffmpeg -i "$input" \
			 -c:v libx264 \
			 -c:a copy \
			 -preset slow \
			 -crf 28 \
			 "$output"

