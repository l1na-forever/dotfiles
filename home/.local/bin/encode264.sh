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


encode() 
{
	input="$1"
	output="$2"
	crf="$3"

	ffmpeg -i "$input" \
				 -c:v libx264 \
				 -c:a libfdk_aac \
				 -b:a 192k \
				 -pix_fmt yuv420p \
				 -movflags +faststart \
				 -preset slow \
				 -crf "$crf" \
				 -vf "scale=1920:-2" \
				 "$output"
}

encode "$1" "$2" "24"

