resource "aws_s3_bucket" "postgres_backup" {
  bucket = var.postgres_bucket
}

resource "aws_s3_bucket" "elasticsearch_backup" {
  bucket = var.elasticsearch_bucket
}

resource "aws_s3_bucket" "etcd_backup" {
  bucket = var.etcd_bucket
}

resource "kubernetes_config_map" "backup_scripts" {
  metadata {
    name      = "backup-scripts"
    namespace = "default"
  }

  data = {
    "backup_postgres.sh" = <<-EOT
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
    EOT

    "backup_elasticsearch.sh" = <<-EOT
      #!/bin/bash
      TIMESTAMP=$(date +"%F-%H-%M-%S")
      SNAPSHOT_NAME="es-snapshot-$TIMESTAMP"
      ES_HOST="${var.elasticsearch_host}"
      REPOSITORY_NAME="s3-backup-repo"

      curl -X PUT "$ES_HOST/_snapshot/$REPOSITORY_NAME/$SNAPSHOT_NAME?wait_for_completion=true"
    EOT

    "backup_etcd.sh" = <<-EOT
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
    EOT
  }
}

resource "kubernetes_manifest" "postgres_backup_cronjob" {
  manifest = <<-EOT
    apiVersion: batch/v1beta1
    kind: CronJob
    metadata:
      name: postgres-backup
      namespace: default
    spec:
      schedule: "0 2 * * *"
      jobTemplate:
        spec:
          template:
            spec:
              containers:
              - name: postgres-backup
                image: amazonlinux:2
                env:
                - name: PGUSER
                  value: "${var.postgres_user}"
                - name: PGPASSWORD
                  value: "${var.postgres_password}"
                - name: PGHOST
                  value: "${var.postgres_host}"
                - name: PGDATABASE
                  value: "${var.postgres_db}"
                - name: AWS_ACCESS_KEY_ID
                  value: "your_aws_access_key_id"
                - name: AWS_SECRET_ACCESS_KEY
                  value: "your_aws_secret_access_key"
                volumeMounts:
                - name: backup-scripts
                  mountPath: /scripts
                command: ["/bin/bash", "-c", "/scripts/backup_postgres.sh"]
              volumes:
              - name: backup-scripts
                configMap:
                  name: backup-scripts
              restartPolicy: OnFailure
  EOT
}

resource "kubernetes_manifest" "elasticsearch_backup_cronjob" {
  manifest = <<-EOT
    apiVersion: batch/v1beta1
    kind: CronJob
    metadata:
      name: elasticsearch-backup
      namespace: default
    spec:
      schedule: "0 3 * * *"
      jobTemplate:
        spec:
          template:
            spec:
              containers:
              - name: elasticsearch-backup
                image: amazonlinux:2
                env:
                - name: ES_HOST
                  value: "${var.elasticsearch_host}"
                - name: AWS_ACCESS_KEY_ID
                  value: "your_aws_access_key_id"
                - name: AWS_SECRET_ACCESS_KEY
                  value: "your_aws_secret_access_key"
                volumeMounts:
                - name: backup-scripts
                  mountPath: /scripts
                command: ["/bin/bash", "-c", "/scripts/backup_elasticsearch.sh"]
              volumes:
              - name: backup-scripts
                configMap:
                  name: backup-scripts
              restartPolicy: OnFailure
  EOT
}

resource "kubernetes_manifest" "etcd_backup_cronjob" {
  manifest = <<-EOT
    apiVersion: batch/v1beta1
    kind: CronJob
    metadata:
      name: etcd-backup
      namespace: default
    spec:
      schedule: "0 4 * * *"
      jobTemplate:
        spec:
          template:
            spec:
              containers:
              - name: etcd-backup
                image: amazonlinux:2
                env:
                - name: ETCD_ENDPOINTS
                  value: "${var.etcd_endpoints}"
                - name: ETCD_CERT
                  value: "${var.etcd_cert}"
                - name: ETCD_KEY
                  value: "${var.etcd_key}"
                - name: ETCD_CA_CERT
                  value: "${var.etcd_ca_cert}"
                - name: AWS_ACCESS_KEY_ID
                  value: "your_aws_access_key_id"
                - name: AWS_SECRET_ACCESS_KEY
                  value: "your_aws_secret_access_key"
                volumeMounts:
                - name: backup-scripts
                  mountPath: /scripts
                command: ["/bin/bash", "-c", "/scripts/backup_etcd.sh"]
              volumes:
              - name: backup-scripts
                configMap:
                  name: backup-scripts
              restartPolicy: OnFailure
  EOT
}
