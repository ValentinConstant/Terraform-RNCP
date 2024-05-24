output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.aws_vpc.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  value       = module.vpc.aws_nat_gateway.id
}

output "internet_gateway_id" {
  description = "The IDs of the Internet gateway"
  value       = module.vpc.aws_internet_gateway.id
}