#!/bin/sh
umask 077
wget https://github.com/gpolcode/backup-pi/archive/refs/heads/main.tar.gz -O /tmp/main.tar.gz
tar -xzf /tmp/main.tar.gz -C /tmp
tar -C /tmp/backup-pi-main -cf - . | tar -C / -xpf -
