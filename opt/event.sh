#!/bin/sh
curl https://hc-ping.com/e714f0fb-3e73-4add-afbf-b8860a12f433/fail \
 --request POST \
 --data "$1 $2"