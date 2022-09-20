#!/bin/bash
grimshot save area "$HOME/Pictures/Screenshots/screenshot_$(date +%Y%m%d_%H%M%S%N).webp"
dunstify "Screenshot saved" &
