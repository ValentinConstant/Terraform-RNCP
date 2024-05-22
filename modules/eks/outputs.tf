output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "kubeconfig" {
  description = "Kubeconfig file"
  value       = module.eks.kubeconfig
}
