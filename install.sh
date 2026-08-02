#!/bin/sh
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
LINK_TARGET=/etc/systemd/user/backup.service

ln -sf "$SCRIPT_DIR/backup.service" "$LINK_TARGET"
echo "Linked $LINK_TARGET -> $SCRIPT_DIR/backup.service"
