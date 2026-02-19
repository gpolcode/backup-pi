#!/bin/sh
. /root/enable-logging.sh

status="$(zpool status -x 2>&1)"
if [ "$status" != "all pools are healthy" ]; then
  printf '%s' "$status"
  exit 1
fi
