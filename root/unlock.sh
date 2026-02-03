#!/bin/sh

read -s -p "Enter password: " password
printf "$password"> /tmp/backup-pass
chmod 400 /tmp/backup-pass

rclone mount gdrive: /mnt/data/rclone/gdrive \
  --daemon \
  --read-only \
  --cache-dir /tmp/gdrive \
  --vfs-cache-mode full \
  --vfs-cache-max-size 1G \
  --vfs-read-ahead 128M \
  --vfs-read-chunk-streams 64 \
  --vfs-read-chunk-size 16M
  