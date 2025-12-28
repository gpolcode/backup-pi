#!/bin/sh
. $HOME/.profile
TMP="$(mktemp)"

restic check --read-data --retry-lock 10m >"$TMP" 2>&1
rc=$?

if [ "$rc" -ne 0 ]; then
  wget --post-file "$TMP" "$PING_URL/fail" -O /dev/null || true
fi

rm -f "$TMP"
