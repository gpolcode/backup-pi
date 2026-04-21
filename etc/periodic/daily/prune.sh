#!/bin/sh
. /root/enable-logging.sh

restic forget --keep-last 62 --keep-hourly 24 --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 3 --prune --retry-lock 15m
