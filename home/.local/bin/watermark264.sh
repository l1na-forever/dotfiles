#!/bin/bash
set -eo pipefail

_help() {
	cat << EOF
USAGE: $(basename $0) <input_file> <watermark_file> <output_file>

Encodes the given input file with a high-quality/slow libx264 preset, adding the given watermark.			
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
_SCALE="0.15"
_ALPHA="0.8"

ffmpeg -i "$input" \
			 -i "$watermark" \
			 -filter_complex "[1][0]scale2ref=w=oh*mdar:h=ih*$_SCALE[logo][video];[logo]format=rgba,colorchannelmixer=aa=$_ALPHA[logo];[video][logo]overlay=W-w-$_PADDING:H-h-$_PADDING:format=auto,format=yuv420p" \
			 -c:v libx264 \
			 -c:a copy \
			 -preset slow \
			 -crf 28 \
			 "$output"
