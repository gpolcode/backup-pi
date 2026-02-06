#!/bin/sh

umask 077
read -s -p "Enter password: " password
printf '%s' "$password" > /tmp/backup-pass
chmod 400 /tmp/backup-pass
unset password

rclone mount gdrive: "$RCLONE_PATH" \
  --daemon \
  --read-only \
  --cache-dir /tmp/gdrive \
  --rc \
  --rc-addr 127.0.0.1:5572 \
  --vfs-cache-mode full \
  --vfs-cache-max-size 1G \
  --vfs-cache-max-age 24h \
  --dir-cache-time 24h \
  --attr-timeout 5s \
  --poll-interval 1m \
  --vfs-refresh \
  --vfs-read-ahead 128M \
  --vfs-read-chunk-streams 64 \
  --vfs-read-chunk-size 16M
