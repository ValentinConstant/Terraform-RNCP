variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
