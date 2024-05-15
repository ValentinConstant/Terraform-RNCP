#!/bin/bash
TIMESTAMP=$(date +"%F-%H-%M-%S")
BACKUP_FILE="/tmp/postgres-backup-$TIMESTAMP.sql.gz"
PGUSER="${var.postgres_user}"
PGPASSWORD="${var.postgres_password}"
PGHOST="${var.postgres_host}"
PGDATABASE="${var.postgres_db}"

export PGPASSWORD
pg_dump -U $PGUSER -h $PGHOST $PGDATABASE | gzip > $BACKUP_FILE
aws s3 cp $BACKUP_FILE s3://${var.postgres_bucket}/
rm $BACKUP_FILE