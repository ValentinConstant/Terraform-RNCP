output "cluster_name" {
  description = "EKS cluster name"
  value       = var.cluster_name
}

output "etcd_backup_bucket" {
  description = "S3 bucket for etcd backups"
  value       = module.s3.etcd_backup_bucket
}

output "postgres_backup_bucket" {
  description = "S3 bucket for PostgreSQL backups"
  value       = module.s3.postgres_backup_bucket
}

output "elasticsearch_backup_bucket" {
  description = "S3 bucket for Elasticsearch backups"
  value       = module.s3.elasticsearch_backup_bucket
}