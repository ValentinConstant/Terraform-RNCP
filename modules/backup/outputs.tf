output "postgres_backup_bucket" {
  value = aws_s3_bucket.postgres_backup.bucket
}

output "elasticsearch_backup_bucket" {
  value = aws_s3_bucket.elasticsearch_backup.bucket
}

output "etcd_backup_bucket" {
  value = aws_s3_bucket.etcd_backup.bucket
}
