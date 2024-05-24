output "cluster_name" {
  description = "EKS cluster name"
  value       = var.cluster_name
}

output "etcd_backup_bucket" {
  description = "S3 bucket for etcd backups"
  value       = module.storage.etcd_backup_bucket
}

output "postgres_backup_bucket" {
  description = "S3 bucket for PostgreSQL backups"
  value       = module.storage.postgres_backup_bucket
}

output "elasticsearch_backup_bucket" {
  description = "S3 bucket for Elasticsearch backups"
  value       = module.storage.elasticsearch_backup_bucket
}

output "efs_storage" {
  description = "EFS storage for jenkins"
  value       = module.storage.efs_storage
}