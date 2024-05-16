output "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "bastion_profile_name" {
  description = "Name of the bastion instance profile"
  value       = aws_iam_instance_profile.bastion_profile.name
}
