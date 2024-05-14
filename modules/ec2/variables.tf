variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the master node"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the worker nodes"
  type        = list(string)
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 3
}