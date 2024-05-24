output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  value       = aws_nat_gateway.nat.id
}

output "internet_gateway_id" {
  description = "The IDs of the Internet gateway"
  value       = aws_internet_gateway.igw.id
}

output "eip" {
  description = "The IP of eip"
  value       = aws_eip.nat.address
}