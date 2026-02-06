. /root/backup-pi.env

export ZPOOL_DISKS="/dev/sda /dev/sdb /dev/sdc /dev/sdd"
export RCLONE_PASSWORD_COMMAND="cat /tmp/backup-pass"
export RESTIC_PASSWORD_COMMAND=$RCLONE_PASSWORD_COMMAND
export RESTIC_REPOSITORY="/mnt/backup"
export RCLONE_PATH="/mnt/data/rclone/gdrive"
