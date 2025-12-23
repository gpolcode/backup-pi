#!/bin/sh
. $HOME/.profile
TMP="$(mktemp)"

restic backup /mnt/data/rclone/gdrive/ -v >"$TMP" 2>&1
rc=$?

if [ "$rc" -eq 0 ]; then
  wget --post-file "$TMP" "$PING_URL" -O /dev/null
else
  wget --post-file "$TMP" "$PING_URL/fail" -O /dev/null || true
fi

rm -f "$TMP"
