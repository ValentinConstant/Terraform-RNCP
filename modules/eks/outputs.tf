output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.aws_eks_cluster.cluster_id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.aws_eks_cluster.cluster_name
}