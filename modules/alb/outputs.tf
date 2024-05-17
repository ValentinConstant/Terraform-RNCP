output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.k3s_lb.dns_name
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.k3s_lb.arn
}

