#!/bin/sh

umask 077
read -s -p "Enter password: " password
printf '%s' "$password" > /tmp/backup-pass
chmod 400 /tmp/backup-pass
unset password

# The VFS cache holds plaintext copies of Drive files, so it must stay off
# persistent storage for the same reason the key does. A dedicated tmpfs keeps
# it in RAM and caps it independently of the rest of the rootfs.
CACHE_DIR=/tmp/rclone-cache
mkdir -p "$CACHE_DIR"
if ! grep -q " $CACHE_DIR tmpfs " /proc/mounts; then
  mount -t tmpfs -o size=1G,mode=0700,noexec,nosuid,nodev tmpfs "$CACHE_DIR"
fi

rclone mount gdrive: "$RCLONE_PATH" \
  --daemon \
  --read-only \
  --cache-dir "$CACHE_DIR" \
  --vfs-cache-mode full \
  --vfs-cache-max-size 512M \
  --vfs-cache-max-age 10m \
  --low-level-retries 20
