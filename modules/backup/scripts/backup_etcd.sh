#!/bin/bash
TIMESTAMP=$(date +"%F-%H-%M-%S")
BACKUP_FILE="/tmp/etcd-backup-$TIMESTAMP.db"
ETCDCTL_API=3
ETCD_ENDPOINTS="${var.etcd_endpoints}"
ETCD_CERT="${var.etcd_cert}"
ETCD_KEY="${var.etcd_key}"
ETCD_CA_CERT="${var.etcd_ca_cert}"

etcdctl --endpoints=$ETCD_ENDPOINTS --cert=$ETCD_CERT --key=$ETCD_KEY --cacert=$ETCD_CA_CERT snapshot save $BACKUP_FILE
aws s3 cp $BACKUP_FILE s3://${var.etcd_bucket}/
rm $BACKUP_FILE