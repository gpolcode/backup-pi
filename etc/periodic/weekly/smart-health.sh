#!/bin/sh
. "$HOME/.profile"

output="$(
  for disk in $ZPOOL_DISKS; do
    smartctl -a "$disk" 2>&1 || exit 1
  done
)"
rc=$?

if [ "$rc" -ne 0 ]; then
  wget --post-data "$output" "$PING_URL/fail" -O /dev/null || true
fi
