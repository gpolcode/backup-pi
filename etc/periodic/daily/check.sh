#!/bin/sh
. "$HOME/.profile"

output="$(restic check --read-data --retry-lock 10m 2>&1)"
rc=$?

if [ "$rc" -ne 0 ]; then
  wget --post-data "$output" "$PING_URL/fail" -O /dev/null || true
fi
