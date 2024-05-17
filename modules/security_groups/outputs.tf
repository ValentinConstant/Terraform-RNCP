output "ec2_sg_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
}

output "bastion_sg_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion_sg.id
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
}