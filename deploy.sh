#!/bin/sh
umask 077
wget https://github.com/gpolcode/backup-pi/archive/refs/heads/main.tar.gz -O /tmp/main.tar.gz
tar -xzf /tmp/main.tar.gz -C /tmp

SRC=/tmp/backup-pi-main
find "$SRC" -type f | while read -r f; do
    cp -f "$f" "/${f#$SRC/}"
    chmod 700 "/${f#$SRC/}"
done

if [ -z "$PING_URL" ]; then
    read -s -p "Enter healthcheck.io ping_key: " PING_KEY
    printf "export PING_URL='https://hc-ping.com/$PING_KEY'"> /root/backup-pi.env
    . ~/.profile
fi
