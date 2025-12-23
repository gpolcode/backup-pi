# backup-pi

Connect with:  
```sh
ssh root@192.168.1.81
```

Unlock:  
```sh
sh ./unlock.sh
```

OAuth Client:  
https://console.cloud.google.com/auth/overview?project=rclone-sync-481117

rclone setup:  
https://rclone.org/drive/

```mermaid
graph TD;
    Takeout-->Drive;
    Computer-->Drive;
    Drive-->Pi;
```

Packages:  
- gpg
- pass
- restic
- zfs
- rclone
- fuse3
