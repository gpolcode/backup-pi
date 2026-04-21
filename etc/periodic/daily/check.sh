#!/bin/sh
. /root/enable-logging.sh

restic check --read-data --retry-lock 15m
