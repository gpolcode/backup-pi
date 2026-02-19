#!/bin/sh
. /root/.profile
umask 077
LOG_FILE="$(mktemp)" || exit 1

healthcheck_exit() {
  rc=$?
  trap - EXIT

  exec 1>&3 2>&4
  exec 3>&- 4>&-

  wget -q --post-file "$LOG_FILE" "$PING_URL/$rc" -O /dev/null || true

  rm -f "$LOG_FILE"
  exit "$rc"
}

wget -q "$PING_URL/start" -O /dev/null || true
exec 3>&1 4>&2
exec 1>>"$LOG_FILE" 2>&1
trap 'healthcheck_exit' EXIT
