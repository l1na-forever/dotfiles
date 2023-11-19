#!/bin/bash
set -eo pipefail

notify() {
  dunstify -h "string:x-canonical-private-synchronous:is-dnd" "$1"
}

mode=$(makoctl mode)
if [[ "$mode" == "default" ]]; then
  # hide notifications
  notify "💤 Hiding Notifications"; sleep 2
  makoctl mode -a do-not-disturb
else
  # show notifications
  makoctl mode -r do-not-disturb
  notify "🌄 Showing Notifications"
fi

