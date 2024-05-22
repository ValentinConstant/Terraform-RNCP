variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones in the region"
  type        = list(string)
}

variable "key_name" {
  description = "The key name to use for the EC2 instances"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the ACM certificate"
  type        = string
}

variable "route53_zone_id" {
  description = "The Route53 Hosted Zone ID for the domain"
  type        = string
}

variable "prefix" {
  description = "Prefix for the S3 buckets"
  type        = string
}

variable "environment" {
  description = "Environment for tagging purposes"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "instance_type" {
  description = "Instance type for the worker nodes"
  type        = string
}

variable "jenkins_admin_password" {
  description = "Admin password for Jenkins"
  type        = string
  sensitive   = true
}
