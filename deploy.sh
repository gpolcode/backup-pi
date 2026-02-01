#!/bin/sh
wget https://github.com/gpolcode/backup-pi/archive/refs/heads/main.tar.gz -O /tmp/main.tar.gz
tar -xzf /tmp/main.tar.gz -C /tmp

SRC=/tmp/backup-pi-main
find $SRC -type f | while read -r f; do
    cp -f "$f" "/${f#$SRC/}"
    chmod 700 "/${f#$SRC/}"
done
