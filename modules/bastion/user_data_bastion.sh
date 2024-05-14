#!/bin/bash
# Update the package list and install necessary packages
sudo apt-get update
sudo apt-get install -y curl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash