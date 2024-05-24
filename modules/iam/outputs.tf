output "eks_role_cluster" {
  description = "The ARN of the EKS cluster role"
  value       = aws_iam_role.eks_role.arn
}

output "eks_role_nodes" {
  description = "The ARN of the nodes role"
  value = aws_iam_role.nodes.arn
}

output "cluster_policy"{
  description = "IAM policy for cluster"
  value = aws_iam_role_policy_attachment.eks_cluster_policy.id
}

output "workers_policy"{
  description = "workers_node_policy"
  value = aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy.id
}

output "cni_policy"{
  description = "EKS CNI policy"
  value = aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy.id
}

output "ec2_container_registry"{
  description = "EC2 container registry policy"
  value = aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly.id
}