#!/bin/sh
. /root/enable-logging.sh

zpool scrub -a
