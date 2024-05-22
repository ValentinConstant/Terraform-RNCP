output "eks_role_arn" {
  description = "The ARN of the EKS cluster role"
  value       = aws_iam_role.eks.arn
}

output "node_role_arn" {
  description = "The ARN of the EKS node role"
  value       = aws_iam_role.node.arn
}
