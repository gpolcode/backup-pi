#!/bin/sh
. /root/enable-logging.sh

for disk in $ZPOOL_DISKS; do
  smartctl -a "$disk" || exit 1
done
