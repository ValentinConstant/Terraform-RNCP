# output "kubeconfig" {
#   description = "Kubeconfig file"
#   value       = module.eks.kubeconfig
# }

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

# output "traefik_load_balancer_dns" {
#   description = "The DNS name of the Traefik load balancer"
#   value       = module.traefik.traefik_load_balancer_dns
# }

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

# output "jenkins_url" {
#   description = "URL for Jenkins"
#   value       = module.jenkins.jenkins_url
# }