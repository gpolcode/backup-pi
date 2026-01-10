#!/bin/sh

cd /tmp
wget https://github.com/gpolcode/backup-pi/archive/refs/heads/main.tar.gz -O main.tar.gz
tar -xzf main.tar.gz
cd /tmp/backup-pi-main
tar -cf - . | (cd / && tar -xpf -)
