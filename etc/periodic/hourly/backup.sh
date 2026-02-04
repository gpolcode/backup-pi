#!/bin/sh
. $HOME/.profile
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

wget --post-file "$TMP" "$PING_URL/start" -O /dev/null

if ! mountpoint -q "$RCLONE_MOUNT_PATH"; then
  echo "Mount missing: $RCLONE_MOUNT_PATH" >"$TMP"
  wget --post-file "$TMP" "$PING_URL/fail" -O /dev/null || true
  exit 1
fi

restic backup "$RCLONE_MOUNT_PATH"/ -v --retry-lock 10m >"$TMP" 2>&1
rc=$?

if [ "$rc" -eq 0 ]; then
  wget --post-file "$TMP" "$PING_URL" -O /dev/null
else
  wget --post-file "$TMP" "$PING_URL/fail" -O /dev/null || true
fi
