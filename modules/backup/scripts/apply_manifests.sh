#!/bin/bash

# Export the necessary variables for substitution
export ES_HOST="${elasticsearch_service_name}.${elasticsearch_namespace}.svc.cluster.local"
export ELASTICSEARCH_BUCKET="${elasticsearch_bucket}"
export AWS_ACCESS_KEY_ID="${aws_access_key_id}"
export AWS_SECRET_ACCESS_KEY="${aws_secret_access_key}"
export ETCD_BUCKET="${etcd_bucket}"
export POSTGRES_USER="${postgres_user}"
export POSTGRES_PASSWORD="${postgres_password}"
export POSTGRES_SERVICE_NAME="${postgres_service_name}"
export POSTGRES_NAMESPACE="${postgres_namespace}"
export POSTGRES_DB="${postgres_db}"
export POSTGRES_BUCKET="${postgres_bucket}"

# Use envsubst to replace the variables in the manifests
envsubst < "${path.module}/manifests/backup_elasticsearch_cronjob.yaml" | kubectl apply -f -
envsubst < "${path.module}/manifests/backup_postgres_cronjob.yaml" | kubectl apply -f -
envsubst < "${path.module}/manifests/backup_etcd_cronjob.yaml" | kubectl apply -f -
