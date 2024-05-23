output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
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

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnets
}