#!/bin/bash

# Update the package list and install packages
sudo apt-get update
sudo apt-get install -y curl unzip 

# Install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

curl -sfL https://get.k3s.io | sh -s

# Fix k3s rights
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

# Extract token K3s for workers
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

# Extract private master ip
SECRET_NAME_K3S="k3s-secrets"
SERVER_URL=$(hostname -I | awk '{print $1}')
K3S_URL="https://${SERVER_URL}:6443"

# Add IP to k3s config
file_path="/etc/rancher/k3s/k3s.yaml"
sed -i "s|server: https://127.0.0.1:6443|server: ${K3S_URL}|" "$file_path"

#  Add config to /.kube/config
mkdir ~/.kube
sudo kubectl config view --raw > ~/.kube/config

# Save master datas to AWS Secrets Manager
aws secretsmanager update-secret --secret-id $SECRET_NAME_K3S --secret-string "{\"k3s_token\":\"$TOKEN\", \"k3s_url\":\"$K3S_URL\"}"
