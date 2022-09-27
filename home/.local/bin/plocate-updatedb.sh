#!/bin/bash
DBPATH="$HOME/.local/lib/plocate/plocate.db"
PRUNEPATHS="/tmp /var/spool"
PRUNENAMES=".git"
PRUNE_BIND_MOUNTS="1"
PRUNEFS="proc sysfs tmpfs devtmpfs devpts cgroup cgroup2 nsfs fuse.portal securityfs efivarfs"
updatedb -l 0 --prunenames "$PRUNENAMES" \
              --prunepaths "PRUNEPATHS" \
              --prunefs "$PRUNEFS" \
              --prune-bind-mounts "$PRUNE_BIND_MOUNTS" \
              -o "$DBPATH"
