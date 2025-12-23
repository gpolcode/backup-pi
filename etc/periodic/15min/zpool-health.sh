#!/bin/sh
STATUS="$(zpool status -x 2>&1 || true)"

echo "$STATUS" | grep -q "all pools are healthy" && exit 0

wget --post-data "$STATUS" "$PING_URL/fail" -O /dev/null || true
