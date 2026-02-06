#!/bin/sh
. "$HOME/.profile"

output="$(zpool status -x 2>&1)"

if [ "$output" != "all pools are healthy" ]; then
  wget --post-data "$output" "$PING_URL/fail" -O /dev/null || true
fi
