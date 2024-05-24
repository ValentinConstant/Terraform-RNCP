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

output "private_subnet_1" {
  description = "The IP of private subnet 1"
  value       =aws_subnet.private-eu-west-3a.id
}

output "private_subnet_2" {
  description = "The IP of private subnet 2"
  value       =aws_subnet.private-eu-west-3b.id
}

output "public_subnet_1" {
  description = "The IP of public subnet 1"
  value       =aws_subnet.public-eu-west-3a.id
}

output "public_subnet_2" {
  description = "The IP of public subnet 2"
  value       =aws_subnet.public-eu-west-3b.id
}