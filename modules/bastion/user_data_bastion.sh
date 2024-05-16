#!/bin/bash
SECRET_NAME="ssh-key"
REGION="${region}"
SECRET_VALUE=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME --query 'SecretString' --output text --region $REGION)

# Update the package list and install necessary packages
sudo apt-get update
sudo apt-get install -y curl awscli jq

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

echo "$SECRET_VALUE" > /home/ubuntu/.ssh/AWS-RNCP-Infra.pem
chmod 600 /home/ubuntu/.ssh/AWS-RNCP-Infra.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/AWS-RNCP-Infra.pem