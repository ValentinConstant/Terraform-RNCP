variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the master and worker nodes"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "master_subnet_id" {
  description = "The subnet ID for the master node"
  type        = string
}

variable "worker_subnet_ids" {
  description = "The subnet IDs for the worker nodes"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired capacity for the worker node auto-scaling group"
  type        = number
}

variable "max_size" {
  description = "Maximum size for the worker node auto-scaling group"
  type        = number
}

variable "min_size" {
  description = "Minimum size for the worker node auto-scaling group"
  type        = number
}

variable "security_group_id" {
  description = "The security group ID for the master and worker nodes"
  type        = string
}

variable "iam_instance_profile" {
  description = "The IAM instance profile for the master and worker nodes"
  type        = string
}

variable "k3s_token" {
  description = "K3s token for joining the cluster"
  type        = string
}
