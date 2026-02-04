. /root/backup-pi.env

export RCLONE_PASSWORD_COMMAND="cat /tmp/backup-pass"
export RESTIC_PASSWORD_COMMAND="cat /tmp/backup-pass"
export RESTIC_REPOSITORY="/mnt/backup"
export RCLONE_PATH="/mnt/data/rclone/gdrive"
export PING_URL="https://hc-ping.com/$PING_KEY"
