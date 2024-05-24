output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.kbnhvn-cluster.id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.kbnhvn-cluster.name
}