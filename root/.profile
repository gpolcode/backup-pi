. /root/backup-pi.env

export RCLONE_PASSWORD_COMMAND="cat /tmp/backup-pass"
export RESTIC_PASSWORD_COMMAND=$RCLONE_PASSWORD_COMMAND
export RESTIC_REPOSITORY="/mnt/backup"
export RCLONE_PATH="/mnt/data/rclone/gdrive"
