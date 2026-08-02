#!/bin/sh
#
# install.sh
#
# Symlinks backup.service from this repo checkout into the systemd user
# unit directory, then reloads systemd so it picks up the change.
#
set -eu

LINK_TARGET=/etc/systemd/user/backup.service
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ "$(id -u)" -ne 0 ]; then
  echo "install.sh: must be run as root (writes to /etc/systemd/user)" >&2
  exit 1
fi

mkdir -p "$(dirname "$LINK_TARGET")"
ln -sf "$SCRIPT_DIR/backup.service" "$LINK_TARGET"
systemctl daemon-reload

echo "Linked $LINK_TARGET -> $SCRIPT_DIR/backup.service"
