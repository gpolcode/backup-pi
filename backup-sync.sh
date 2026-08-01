#!/bin/sh
#
# backup-sync.sh
#
# 1. Mirror a preconfigured list of GitHub repos into a local directory
#    (clone if missing, otherwise fetch + prune deleted refs, then gc).
# 2. rclone sync a preconfigured map of source -> destination pairs.
#
# Designed to be run from a systemd oneshot service: any failure exits
# non-zero so systemd marks the unit failed and fires its OnFailure= alert.
#
set -eu

########################################
# Configuration
########################################

RCLONE="${RCLONE:-/home/linuxbrew/.linuxbrew/bin/rclone}"

# Where the bare mirror clones live.
MIRROR_DIR="${MIRROR_DIR:-/home/elsahr/backup/github}"

# Repos to mirror. One git URL per line (blank lines ignored).
# To auto-discover instead of hand-listing, replace this block with e.g.:
#   REPOS=$(gh repo list <owner> --limit 1000 --json sshUrl -q '.[].sshUrl')
REPOS="
git@github.com:gpolcode/backup-pi.git
"

# Source -> destination sync map. One "SRC|DST" pair per line.
# SRC and DST are anything rclone understands (local path or remote:path);
# either side may contain spaces.
SYNC_MAP="
/home/elsahr/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/WTF|gdrive:/Persönliche Dokumente/IT/Configs/World of Warcraft/World of Warcraft/
${MIRROR_DIR}|gdrive:/Persönliche Dokumente/IT/Backups/github
"

# Extra flags for rclone sync.
RCLONE_FLAGS="-v"

########################################
# Helpers
########################################

fail() {
  printf 'backup-sync: %s\n' "$*" >&2
  exit 1
}

########################################
# Main
########################################

# --- Step 1: clone / fetch / prune every repo -------------------------------
mkdir -p "$MIRROR_DIR" || fail "cannot create $MIRROR_DIR"

# URLs contain no whitespace, so default word-splitting is safe here.
for url in $REPOS; do
  name=$(basename "$url" .git)
  dest="$MIRROR_DIR/$name.git"

  if [ -d "$dest" ]; then
    printf 'Updating %s\n' "$name"
    git --git-dir="$dest" remote update --prune \
      || fail "fetch failed: $name"
  else
    printf 'Cloning %s\n' "$name"
    git clone --mirror "$url" "$dest" \
      || fail "clone failed: $name"
  fi

  # compact and drop unreferenced objects
  git --git-dir="$dest" gc --prune=now --quiet \
    || fail "gc failed: $name"
done

# --- Step 2: sync each source -> destination pair ---------------------------
# IFS=newline so a SYNC_MAP line stays whole and paths may contain spaces.
OLD_IFS=$IFS
IFS='
'
for pair in $SYNC_MAP; do
  IFS=$OLD_IFS
  [ -n "$pair" ] || { IFS='
'; continue; }

  src=${pair%%|*}
  dst=${pair#*|}

  printf 'Syncing %s -> %s\n' "$src" "$dst"
  # shellcheck disable=SC2086
  "$RCLONE" sync "$src" "$dst" $RCLONE_FLAGS \
    || fail "sync failed: $src -> $dst"

  IFS='
'
done
IFS=$OLD_IFS
