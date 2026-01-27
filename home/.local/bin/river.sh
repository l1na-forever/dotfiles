#!/bin/sh

export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP="XFCE"
export GDK_SCALE=2

timestamp=$(date +%F-%R)
exec dbus-run-session river -log-level debug > /tmp/river-${timestamp}.log 2>&1
