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

resource "aws_efs_mount_target" "jenkins" {
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id = var.private_subnet_1
  security_groups = [var.efs-mount-sg]
}

resource "aws_efs_mount_target" "jenkins" {
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id = var.private_subnet_2
  security_groups = [var.efs-mount-sg]
}

resource "aws_efs_mount_target" "jenkins" {
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id = var.private_subnet_3
  security_groups = [var.efs-mount-sg]
}

resource "aws_efs_access_point" "jenkins" {
  file_system_id = aws_efs_file_system.jenkins.id
  posix_user {
    uid = 1000
    gid = 1000
  }
  root_directory {
    path = "/jenkins"
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = 777
    }
  }
}

data "aws_caller_identity" "current" {}
