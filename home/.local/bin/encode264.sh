#!/bin/bash
set -xeuo pipefail

_help() {
	cat << EOF
	USAGE: ./$0 <input_file> <output_file>
	
	Encodes the given input file with a high-quality/slow libx264 preset.			

EOF
}

input=$1
output=$2
ffmpeg -i $input \
			 -c:v libx264 \
			 -c:a copy \
			 -preset slow \
			 -crf 28 \
			 $output

