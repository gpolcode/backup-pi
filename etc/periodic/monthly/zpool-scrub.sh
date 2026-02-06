#!/bin/sh
. "$HOME/.profile"

output="$(zpool scrub -a 2>&1)"
rc=$?

if [ "$rc" -ne 0 ]; then
  wget --post-data "$output" "$PING_URL/fail" -O /dev/null || true
fi
