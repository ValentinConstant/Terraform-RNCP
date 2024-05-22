variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnets" {
  description = "List of subnets for the ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "The security group ID for the ALB"
  type        = string
}

variable "cert_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "environment" {
  description = "The environment"
  type        = string
}
