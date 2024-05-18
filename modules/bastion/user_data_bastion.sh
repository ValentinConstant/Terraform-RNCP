#!/bin/bash

# Update the package list and install necessary packages
sudo apt-get update
sudo apt-get install -y curl unzip

# Install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Get ssh key
SECRET_NAME="ssh-key"
SECRET_VALUE=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME --query 'SecretString' --output text)

echo "$SECRET_VALUE" > /home/ubuntu/.ssh/AWS-RNCP-Infra.pem
chmod 600 /home/ubuntu/.ssh/AWS-RNCP-Infra.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/AWS-RNCP-Infra.pem