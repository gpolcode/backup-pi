#!/bin/sh
. "$HOME/.profile"

output="$(
  apk update 2>&1 &&
  apk upgrade 2>&1
)"
rc=$?

if [ "$rc" -ne 0 ]; then
  wget --post-data "$output" "$PING_URL/fail" -O /dev/null || true
  exit 1
fi

reboot
