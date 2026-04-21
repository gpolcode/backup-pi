#!/bin/sh
. /root/enable-logging.sh

if ! restic backup "$RCLONE_PATH" -v --retry-lock 15m; then
  exit 1
fi

if restic snapshots latest --json | grep -q '"total_files_processed":0'; then
  printf 'Backup failed with no files processed'
  exit 1
fi
