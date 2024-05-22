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
