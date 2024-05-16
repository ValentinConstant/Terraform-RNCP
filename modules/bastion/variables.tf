variable "ami" {
  description = "AMI ID for the bastion host"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID for the bastion host"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID for the bastion host"
  type        = string
}
