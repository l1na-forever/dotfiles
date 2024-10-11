#!/bin/bash
output_path="$HOME/Pictures/Screenshots/screenshot_$(date +%Y%m%d_%H%M%S%N).webp"
grimshot save screen "$output_path" # grimshot doesn't support river to detect active 😢
magick "$output_path" -crop "50%x100%" "$output_path"
dunstify "Screenshot saved" &
