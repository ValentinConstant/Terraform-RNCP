#!/bin/bash

# Variables
ES_HOST="${var.elasticsearch_service_name}.${var.elasticsearch_namespace}.svc.cluster.local"
ELASTICSEARCH_BUCKET="${var.elasticsearch_bucket}"
AWS_ACCESS_KEY_ID="${var.aws_access_key_id}"
AWS_SECRET_ACCESS_KEY="${var.aws_secret_access_key}"
ETCD_BUCKET="${var.etcd_bucket}"
PG_USER="${var.postgres_user}"
PG_PASSWORD="${var.postgres_password}"
PG_HOST="${var.postgres_service_name}.${var.postgres_namespace}.svc.cluster.local"
PG_DATABASE="${var.postgres_db}"
POSTGRES_BUCKET="${var.postgres_bucket}"

# Remplacement des placeholders et application des manifests
sed -e "s/\${ES_HOST}/$ES_HOST/" -e "s/\${ELASTICSEARCH_BUCKET}/$ELASTICSEARCH_BUCKET/" -e "s/\${AWS_ACCESS_KEY_ID}/$AWS_ACCESS_KEY_ID/" -e "s/\${AWS_SECRET_ACCESS_KEY}/$AWS_SECRET_ACCESS_KEY/" "${path.module}/manifests/backup_elasticsearch_cronjob.yaml" | kubectl apply -f -
sed -e "s/\${PGUSER}/$PG_USER/" -e "s/\${PGPASSWORD}/$PG_PASSWORD/" -e "s/\${PGHOST}/$PG_HOST/" -e "s/\${PGDATABASE}/$PG_DATABASE/" -e "s/\${POSTGRES_BUCKET}/$POSTGRES_BUCKET/" -e "s/\${AWS_ACCESS_KEY_ID}/$AWS_ACCESS_KEY_ID/" -e "s/\${AWS_SECRET_ACCESS_KEY}/$AWS_SECRET_ACCESS_KEY/" "${path.module}/manifests/backup_postgres_cronjob.yaml" | kubectl apply -f -
sed -e "s/\${ETCD_BUCKET}/$ETCD_BUCKET/" -e "s/\${AWS_ACCESS_KEY_ID}/$AWS_ACCESS_KEY_ID/" -e "s/\${AWS_SECRET_ACCESS_KEY}/$AWS_SECRET_ACCESS_KEY/" "${path.module}/manifests/backup_etcd_cronjob.yaml" | kubectl apply -f -