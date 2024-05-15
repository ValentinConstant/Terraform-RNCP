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
    "backup_postgres.sh" = file("${path.module}/scripts/backup_postgres.sh")
    "backup_elasticsearch.sh" = file("${path.module}/scripts/backup_elasticsearch.sh")
    "backup_etcd.sh" = file("${path.module}/scripts/backup_etcd.sh")
  }
}

resource "kubernetes_manifest" "postgres_backup_cronjob" {
  manifest = templatefile("${path.module}/manifests/backup_postgres_cronjob.yaml", {
    PGUSER               = var.postgres_user
    PGPASSWORD           = var.postgres_password
    PGHOST               = "${var.postgres_service_name}.${var.postgres_namespace}.svc.cluster.local"
    PGDATABASE           = var.postgres_db
    POSTGRES_BUCKET      = var.postgres_bucket
    AWS_ACCESS_KEY_ID    = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
  })
}

resource "kubernetes_manifest" "elasticsearch_backup_cronjob" {
  manifest = templatefile("${path.module}/manifests/backup_elasticsearch_cronjob.yaml", {
    ES_HOST              = "${var.elasticsearch_service_name}.${var.elasticsearch_namespace}.svc.cluster.local"
    ELASTICSEARCH_BUCKET = var.elasticsearch_bucket
    AWS_ACCESS_KEY_ID    = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
  })
}

resource "kubernetes_manifest" "etcd_backup_cronjob" {
  manifest = templatefile("${path.module}/manifests/backup_etcd_cronjob.yaml", {
    ETCD_BUCKET          = var.etcd_bucket
    AWS_ACCESS_KEY_ID    = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
  })
}