#!/bin/sh
TMP="$(mktemp)"

restic backup /home/ -v >"$TMP" 2>&1
rc=$?

if [ "$rc" -eq 0 ]; then
  wget --post-file "$TMP" "$PING_URL"
else
  wget --post-file "$TMP" "$PING_URL/fail" || true
fi

rm -f "$TMP"
