#!/bin/bash
curl -sfL https://get.k3s.io | K3S_URL=${K3S_URL} K3S_TOKEN=${K3S_TOKEN} sh -

# Fix k3s rights
sudo chmod 644 /etc/rancher/k3s/k3s.yaml