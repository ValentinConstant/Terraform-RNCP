variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "instance_type" {
  description = "EC2 instance type for the worker nodes"
  type        = string
}

variable "nodes_role_arn" {
  description = "ARN of node role"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of cluster role"
  type        = string
}

