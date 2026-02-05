#!/bin/sh
. "$HOME/.profile"

output="$(restic forget --keep-last 62 --keep-hourly 24 --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 3 --prune --retry-lock 10m 2>&1)"
rc=$?

if [ "$rc" -ne 0 ]; then
  wget --post-data "$output" "$PING_URL/fail" -O /dev/null || true
fi
