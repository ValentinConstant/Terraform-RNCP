#!/bin/bash
TIMESTAMP=$(date +"%F-%H-%M-%S")
BACKUP_DIR="/var/lib/rancher/k3s/server/db/snapshots"
BACKUP_FILE="$BACKUP_DIR/etcd-snapshot-$TIMESTAMP.db"

# Save etcd snapshot
k3s etcd-snapshot save --etcd-snapshot-dir="$BACKUP_DIR"

aws s3 cp $BACKUP_FILE s3://${var.etcd_bucket}/

rm $BACKUP_FILE