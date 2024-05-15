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

resource "null_resource" "apply_manifests" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/apply_manifests.sh"
  }
}