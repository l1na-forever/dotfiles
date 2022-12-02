#!/bin/bash
set -eou pipefail

service="$1"
confdir="$HOME/.config/sv/$service"
runlink="$HOME/service/$service"

notify() {
  dunstify -h "string:x-canonical-private-synchronous:togglesv$service" "$1"
}

if ! [[ -e $confdir ]]; then
  echo "!! $confdir doesn't exist, cannot proceed"
  exit 1
fi

if [ -L $runlink ]; then
  # Toggle service off by removing the symlink
  rm -f $runlink
  notify "💤 Disabled $service"
elif [ -e $runlink ]; then
  echo "!! $runlink exists, but isn't a symlink"
  exit 1
else
  # Toggle service on by linking it
  ln -s $confdir $runlink
  notify "⚡ Enabled $service"
fi

