#!/bin/bash
K3S_URL="https://${MASTER_PRIVATE_IP}:6443"

curl -sfL https://get.k3s.io | K3S_URL=${K3S_URL} K3S_TOKEN=${K3S_TOKEN} sh -