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

resource "aws_efs_file_system" "jenkins" {
  creation_token = "jenkins-storage"

  tags = {
    Name = "Jenkins"
  }
}

resource "aws_efs_access_point" "jenkins" {
  file_system_id = aws_efs_file_system.jenkins.id
  root_directory {
    path = "/jenkins-data"
  }
}

data "aws_caller_identity" "current" {}
