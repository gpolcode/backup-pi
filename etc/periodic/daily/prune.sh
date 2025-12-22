#!/bin/sh
TMP="$(mktemp)"

restic forget --keep-last 50 --keep-hourly 24 --keep-daily 7 --keep-weekly 4 --keep-yearly 3 --prune >"$TMP" 2>&1
rc=$?

if [ "$rc" -ne 0 ]; then
  wget --post-file "$TMP" "$PING_URL/fail" || true
fi

rm -f "$TMP"
