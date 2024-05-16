resource "aws_s3_bucket" "elasticsearch_backup" {
  bucket = var.elasticsearch_bucket
  acl    = "private"
}

resource "aws_s3_bucket" "postgres_backup" {
  bucket = var.postgres_bucket
  acl    = "private"
}

resource "aws_s3_bucket" "etcd_backup" {
  bucket = var.etcd_bucket
  acl    = "private"
}