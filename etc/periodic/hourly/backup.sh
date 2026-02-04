#!/bin/sh
umask 077
. "$HOME/.profile"

wget "$PING_URL/start" -O /dev/null

if ! mountpoint -q "$RCLONE_PATH"; then
  wget --post-data "Mount missing: $RCLONE_PATH" "$PING_URL/fail" -O /dev/null || true
  exit 1
fi

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

restic backup "$RCLONE_PATH" -v --retry-lock 10m >"$TMP" 2>&1
rc=$?

if [ "$rc" -eq 0 ]; then
  wget --post-file "$TMP" "$PING_URL" -O /dev/null
else
  wget --post-file "$TMP" "$PING_URL/fail" -O /dev/null || true
fi
