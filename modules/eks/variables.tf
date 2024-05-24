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

variable "public_subnet_1" {
  description = "ID of public subnet 1"
  type        = string
}

variable "public_subnet_2" {
  description = "ID of public sunet 2"
  type        = string
}

variable "private_subnet_1" {
  description = "ID of private subnet 1"
  type        = string
}

variable "private_subnet_2" {
  description = "ID of private subnet 2"
  type        = string
}

variable "cluster_policy" {
  description = "IAM policy for cluster id"
  type        = string
}

variable "workers_policy" {
  description = "workers_node_policy id"
  type        = string
}

variable "cni_policy" {
  description = "EKS CNI policy id"
  type        = string
}

variable "ec2_container_registry" {
  description = "EC2 container registry policy id"
  type        = string
}

