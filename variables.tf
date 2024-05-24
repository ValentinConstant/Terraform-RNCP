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

variable "cluster_name" {
  description = "The name of the EKS cluster"
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

variable "domain_name" {
  description = "Domain name from cloudns"
  type        = string
}

