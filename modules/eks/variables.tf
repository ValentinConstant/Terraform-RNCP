variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
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
  description = "EC2 instance type for the worker nodes"
  type        = string
}

variable "key_name" {
  description = "The key name to use for the EC2 instances"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "node_role_arn" {
  description = "ARN of node role"
  type        = string
}
