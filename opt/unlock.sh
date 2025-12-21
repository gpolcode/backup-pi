#!/bin/sh

/opt/restic-pass.sh
rclone mount gdrive: /mnt/data/rclone/gdrive \
  --daemon \
  --read-only \
  --cache-dir /mnt/tmpfs \
  --vfs-cache-mode full \
  --vfs-cache-max-size 1.9G \
  --vfs-read-ahead 128M \
  --vfs-read-chunk-streams 64 \
  --vfs-read-chunk-size 16M