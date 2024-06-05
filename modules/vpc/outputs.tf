output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

output "internet_gateway_id" {
  description = "The IDs of the Internet gateway"
  value       = aws_internet_gateway.igw.id
}

output "private_subnet_1" {
  description = "The IP of private subnet 1"
  value       = aws_subnet.private-eu-west-3a.id
}

output "private_subnet_2" {
  description = "The IP of private subnet 2"
  value       = aws_subnet.private-eu-west-3b.id
}

output "private_subnet_3" {
  description = "The IP of private subnet 3"
  value       = aws_subnet.private-eu-west-3c.id
}

output "public_subnet_1" {
  description = "The IP of public subnet 1"
  value       = aws_subnet.public-eu-west-3a.id
}

output "public_subnet_2" {
  description = "The IP of public subnet 2"
  value       = aws_subnet.public-eu-west-3b.id
}

output "public_subnet_3" {
  description = "The IP of public subnet 3"
  value       = aws_subnet.public-eu-west-3c.id
}

output "efs-mount-sg" {
  description = "EFS SG"
  value       = aws_security_group.efs-mount-sg.id
}