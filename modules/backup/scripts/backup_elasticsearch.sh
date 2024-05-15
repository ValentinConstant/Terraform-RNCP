#!/bin/bash
TIMESTAMP=$(date +"%F-%H-%M-%S")
SNAPSHOT_NAME="es-snapshot-$TIMESTAMP"
ES_HOST="${var.elasticsearch_host}"
REPOSITORY_NAME="s3-backup-repo"

curl -X PUT "$ES_HOST/_snapshot/$REPOSITORY_NAME/$SNAPSHOT_NAME?wait_for_completion=true"