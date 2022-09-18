#!/bin/bash
# Controls volume using pamixer, emitting notifications with dunstify.

VOLUME_STEP=3 # percent by which volume is raised or lowered

usage() {
  cat<<END
  Usage: $0 <mode>"

  Available modes:
    increase        increase volume by $VOLUME_STEP%
    decrease        decrease volume by $VOLUME_STEP%
    toggle-mute     toggle mute

END
}

notify() {
  muted=$(pamixer --get-mute)
  volume=$(pamixer --get-volume)

  if [[ $muted == "true" ]]; then
    dunstify -h string:x-canonical-private-synchronous:volume -h int:value:0 Muted
  else
    dunstify -h string:x-canonical-private-synchronous:volume -h int:value:"$volume" Volume
  fi
}

case "$1" in
  increase)
    pamixer -u
    pamixer -i "$VOLUME_STEP"
    ;;

  decrease)
    pamixer -u
    pamixer -d "$VOLUME_STEP"
    ;;

  toggle-mute)
    pamixer -t
    ;;

  *)
    usage
    exit 1
    ;;
esac

notify
