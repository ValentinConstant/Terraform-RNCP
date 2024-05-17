variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets to attach to the ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "The security group ID to attach to the ALB"
  type        = string
}

variable "master_node" {
  description = "Id of master node"
  type        = string
}

variable "workers_asg" {
  description = "id of workers nodes ASG"
  type        = string
}
