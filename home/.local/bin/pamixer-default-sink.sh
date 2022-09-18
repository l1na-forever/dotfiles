#!/bin/bash
# Changes the default sink in pamixer

usage() {
  cat<<END
  Usage: $0 <device name>

  Device name will simply be searched as a substring against all possible
  sinks, with the first match selected.
END
}

notify() {
  # default_sink=$(pamixer --get-default-sink | awk -F'"' '{print $(NF)}' | tail -n 1)
  dunstify -h string:x-canonical-private-synchronous:volume "Output set to $1"
}

if [[ -z "$1" ]]; then
  usage
  exit 1
fi

matching_sink=$(pamixer --list-sinks | grep -iF "$1" | awk -F' ' '{print $1}')
if [[ -z "$matching_sink" ]]; then
  echo "No matching sink found!"
  exit 1
fi
# pamixer --sink seems busted?
pactl set-default-sink "$matching_sink"
notify "$1"
