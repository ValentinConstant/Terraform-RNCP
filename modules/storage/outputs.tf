output "etcd_backup_bucket" {
  description = "S3 bucket for etcd backups"
  value       = aws_s3_bucket.etcd_backup.bucket
}

output "postgres_backup_bucket" {
  description = "S3 bucket for PostgreSQL backups"
  value       = aws_s3_bucket.postgres_backup.bucket
}

output "elasticsearch_backup_bucket" {
  description = "S3 bucket for Elasticsearch backups"
  value       = aws_s3_bucket.elasticsearch_backup.bucket
}

output "efs_storage" {
  description = "EFS storage for jenkins"
  value       = aws_efs_file_system.jenkins.id
}

output "efs_storage_access_point" {
  description = "EFS storage access point for jenkins"
  value       = aws_efs_access_point.jenkins.id
}

output "efs_mount_target_dns" {
  description = "Address of the mount target provisioned."
  value       = aws_efs_mount_target.az_3.mount_target_dns_name
}
