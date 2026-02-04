#!/bin/sh

umask 077
read -s -p "Enter password: " password
printf '%s' "$password" > /tmp/backup-pass
chmod 400 /tmp/backup-pass
unset password

rclone mount gdrive: $RCLONE_PATH \
  --daemon \
  --read-only \
  --cache-dir /tmp/gdrive \
  --vfs-cache-mode full \
  --vfs-cache-max-size 1G \
  --vfs-read-ahead 128M \
  --vfs-read-chunk-streams 64 \
  --vfs-read-chunk-size 16M
