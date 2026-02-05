#!/bin/sh
. "$HOME/.profile"

wget "$PING_URL/start" -O /dev/null || true

output="$(restic backup "$RCLONE_PATH" -v --retry-lock 10m 2>&1)"
rc=$?

if [ "$rc" -ne 0 ]; then
  wget --post-data "$output" "$PING_URL/fail" -O /dev/null || true
  exit 1
fi

snapshot="$(restic snapshots latest --json | grep '"total_files_processed":0')"
if [ ! -z "$snapshot" ]; then
  wget --post-data "Backup failed with no files processed" "$PING_URL/fail" -O /dev/null || true
  exit 1
fi

wget "$PING_URL" -O /dev/null || true
