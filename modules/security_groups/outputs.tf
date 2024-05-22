output "eks_sg_id" {
  description = "The ID of the EKS security group"
  value       = aws_security_group.eks.id
}

output "alb_sg_id" {
  description = "The security group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}