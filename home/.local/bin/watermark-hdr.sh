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
_SCALE="0.17"
_ALPHA="0.8"
_CRF="25"

ffmpeg -i "$input" \
			 -i "$watermark" \
			 -filter_complex "[0]zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p[0p];[1][0p]scale2ref=w=oh*mdar:h=ih*$_SCALE[logo][video];[logo]format=rgba,colorchannelmixer=aa=$_ALPHA[logo];[video][logo]overlay=W-w-$_PADDING:H-h-$_PADDING:format=auto,format=yuv420p" \
			 -c:v libx265 \
			 -s "1080x1920" \
			 -c:a copy \
			 -preset slow \
			 -crf "$_CRF" \
			 "$output"
