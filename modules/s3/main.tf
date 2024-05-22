resource "aws_s3_bucket" "etcd_backup" {
  bucket = "${var.prefix}-etcd-backup-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "${var.prefix}-etcd-backup"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "postgres_backup" {
  bucket = "${var.prefix}-postgres-backup-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "${var.prefix}-postgres-backup"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "elasticsearch_backup" {
  bucket = "${var.prefix}-elasticsearch-backup-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "${var.prefix}-elasticsearch-backup"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "etcd_backup" {
  bucket = aws_s3_bucket.etcd_backup.bucket
  acl    = "private"
}

resource "aws_s3_bucket_acl" "postgres_backup" {
  bucket = aws_s3_bucket.postgres_backup.bucket
  acl    = "private"
}

resource "aws_s3_bucket_acl" "elasticsearch_backup" {
  bucket = aws_s3_bucket.elasticsearch_backup.bucket
  acl    = "private"
}

data "aws_caller_identity" "current" {}
