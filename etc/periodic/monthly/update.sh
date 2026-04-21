#!/bin/sh
. /root/enable-logging.sh

if ! apk update; then
  exit 1
fi

if ! apk upgrade; then
  exit 1
fi

reboot
