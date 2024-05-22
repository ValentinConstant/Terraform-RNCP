variable "name" {
  description = "The name of the VPC"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of public subnet CIDR blocks"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
