#! /bin/bash

pvcreate /dev/xvdb
vgcreate backup-dump /dev/xvdb
lvcreate -n backup-dump-vol --extents 100%FREE backup-dump
mkfs.xfs /dev/backup-dump/backup-dump-vol 
blkid | grep backup--dump
echo "Add the above UUID to /etc/fstab mapping it to /backups"
