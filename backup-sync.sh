#!/bin/sh
#
# backup-sync.sh
#
# 1. Mirror every GitHub repo owned by GITHUB_OWNER into a local directory
#    (clone if missing, otherwise fetch + prune deleted refs, then gc).
# 2. rclone sync a preconfigured map of source -> destination pairs.
#
# Run from a systemd oneshot service: any failure exits non-zero so
# systemd marks the unit failed and fires its OnFailure= alert.
#
set -eu

########################################
# Configuration
########################################

RCLONE=/home/linuxbrew/.linuxbrew/bin/rclone
MIRROR_DIR=/home/elsahr/backup/github

GITHUB_OWNER=gpolcode

# One "SRC|DST" pair per line. SRC/DST are anything rclone understands
# (local path or remote:path) and may contain spaces.
SYNC_MAP="
/home/elsahr/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/WTF|gdrive:/Persönliche Dokumente/IT/Configs/World of Warcraft/World of Warcraft/
${MIRROR_DIR}|gdrive:/Persönliche Dokumente/IT/Backups/github
"

########################################

fail() {
  printf 'backup-sync: %s\n' "$*" >&2
  exit 1
}

mirror_repos() {
  mkdir -p "$MIRROR_DIR" || fail "cannot create $MIRROR_DIR"

  repos=$(gh repo list "$GITHUB_OWNER" --limit 1000 --json sshUrl -q '.[].sshUrl') \
    || fail "gh repo list failed"

  # URLs contain no whitespace, so default word-splitting is safe here.
  for url in $repos; do
    name=$(basename "$url" .git)
    dest="$MIRROR_DIR/$name.git"

    if [ -d "$dest" ]; then
      printf 'Updating %s\n' "$name"
      git --git-dir="$dest" remote update --prune || fail "fetch failed: $name"
    else
      printf 'Cloning %s\n' "$name"
      git clone --mirror "$url" "$dest" || fail "clone failed: $name"
    fi

    git --git-dir="$dest" gc --prune=now --quiet || fail "gc failed: $name"
  done
}

sync_all() {
  # IFS=newline so each SYNC_MAP line stays whole and paths may contain spaces.
  old_ifs=$IFS
  IFS='
'
  for pair in $SYNC_MAP; do
    [ -n "$pair" ] || continue
    src=${pair%%|*}
    dst=${pair#*|}

    printf 'Syncing %s -> %s\n' "$src" "$dst"
    IFS=$old_ifs
    "$RCLONE" sync "$src" "$dst" -v || fail "sync failed: $src -> $dst"
    IFS='
'
  done
  IFS=$old_ifs
}

mirror_repos
sync_all
