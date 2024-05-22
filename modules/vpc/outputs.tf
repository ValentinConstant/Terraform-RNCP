output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnets
}

output "nat_gateway_ids" {
  description = "The IDs of the NAT gateways"
  value       = module.vpc.natgw_ids
}

output "internet_gateway_id" {
  description = "The IDs of the Internet gateways"
  value       = module.vpc.igw_id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables"
  value       = module.vpc.private_route_table_ids
}
