output "eks_role_arn" {
  description = "The ARN of the EKS cluster role"
  value       = aws_iam_role.eks_role.arn
}
