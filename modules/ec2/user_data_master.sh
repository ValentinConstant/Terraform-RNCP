#!/bin/bash

SECRET_NAME_SSH="ssh-key"
SECRET_NAME_K3S="k3s-secrets"
SECRET_SSH_VALUE=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME_SSH --query 'SecretString' --output text)

# Update the package list and install packages
sudo apt-get update
sudo apt-get install -y curl unzip

# Install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Get SSH key
echo "$SECRET_SSH_VALUE" > /home/ubuntu/.ssh/AWS-RNCP-Infra.pem
chmod 600 /home/ubuntu/.ssh/AWS-RNCP-Infra.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/AWS-RNCP-Infra.pem

curl -sfL https://get.k3s.io | sh -s - server --node-name master

# Fix k3s rights
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

# Extract token K3s for workers
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

# Extract private master ip
SERVER_URL=$(hostname -I | awk '{print $1}')
K3S_URL="https://${SERVER_URL}:6443"

# Save master datas to AWS Secrets Manager
aws secretsmanager create-secret --name $SECRET_NAME_K3S --secret-string "{\"k3s_token\":\"$TOKEN\", \"k3s_url\":\"$K3S_URL\"}"
