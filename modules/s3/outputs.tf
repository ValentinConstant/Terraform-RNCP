output "elasticsearch_bucket_arn" {
  description = "ARN of the Elasticsearch backup bucket"
  value       = aws_s3_bucket.elasticsearch_backup.arn
}

output "postgres_bucket_arn" {
  description = "ARN of the PostgreSQL backup bucket"
  value       = aws_s3_bucket.postgres_backup.arn
}

output "etcd_bucket_arn" {
  description = "ARN of the ETCD backup bucket"
  value       = aws_s3_bucket.etcd_backup.arn
}
