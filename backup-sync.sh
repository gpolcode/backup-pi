#!/bin/bash
#
# backup-sync.sh
#
# 1. Clone every GitHub repo owned by GITHUB_OWNER into a local directory
#    (clone if missing, otherwise fetch + prune deleted branches, then gc).
# 2. rclone sync a preconfigured map of source -> destination pairs.
#
# Run from a systemd oneshot service: any failure exits non-zero so
# systemd marks the unit failed and fires its OnFailure= alert.
#
set -euo pipefail

RCLONE=/home/linuxbrew/.linuxbrew/bin/rclone
MIRROR_DIR=/home/elsahr/Documents/github

GITHUB_OWNER=gpolcode

declare -A SYNC_MAP=(
  ["/home/elsahr/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/WTF"]="gdrive:/Persönliche Dokumente/IT/Configs/World of Warcraft/World of Warcraft/"
  ["$MIRROR_DIR"]="gdrive:/Persönliche Dokumente/IT/github"
)

fail() {
  printf 'backup-sync: %s\n' "$*" >&2
  exit 1
}

mirror_repos() {
  mkdir -p "$MIRROR_DIR" || fail "cannot create $MIRROR_DIR"

  local repos=()
  mapfile -t repos < <(gh repo list "$GITHUB_OWNER" --limit 1000 --json sshUrl -q '.[].sshUrl') \
    || fail "gh repo list failed"

  local url name dest
  for url in "${repos[@]}"; do
    name=$(basename "$url" .git)
    dest="$MIRROR_DIR/$name"

    if [ -d "$dest" ]; then
      printf 'Updating %s\n' "$name"
      git -C "$dest" fetch --prune || fail "fetch failed: $name"
    else
      printf 'Cloning %s\n' "$name"
      git clone "$url" "$dest" || fail "clone failed: $name"
    fi

    git -C "$dest" gc --prune=now --quiet || fail "gc failed: $name"
  done
}

sync_all() {
  local src dst
  for src in "${!SYNC_MAP[@]}"; do
    dst=${SYNC_MAP[$src]}
    printf 'Syncing %s -> %s\n' "$src" "$dst"
    "$RCLONE" sync "$src" "$dst" -v || fail "sync failed: $src -> $dst"
  done
}

mirror_repos
sync_all
