#!/bin/sh
umask 077
. "$HOME/.profile"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

restic forget --keep-last 50 --keep-hourly 24 --keep-daily 7 --keep-weekly 4 --keep-yearly 3 --prune --retry-lock 10m >"$TMP" 2>&1
rc=$?

if [ "$rc" -ne 0 ]; then
  wget --post-file "$TMP" "$PING_URL/fail" -O /dev/null || true
fi
