#!/bin/bash

# Update the package list and install packages
sudo apt-get update
sudo apt-get install -y curl unzip jq

# Install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Get K3S master datas
SECRET_NAME_K3S="k3s-secrets"
SECRETS_K3S_VALUE=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME_K3S --query 'SecretString' --output text)
K3S_TOKEN=$(echo $SECRETS_K3S_VALUE | jq -r '.k3s_token')
K3S_URL=$(echo $SECRETS_K3S_VALUE | jq -r '.k3s_url')
# KUBECONFIG=$(echo $SECRETS_K3S_VALUE | jq -r '.kubeconfig')

# Install K3s
curl -sfL https://get.k3s.io | K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -

# Fix k3s rights
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

# Get kubeconfig
# mkdir ~/.kube
# echo "$KUBECONFIG" > ~/.kube/config

# Installer Helm seulement s'il n'est pas déjà installé
if ! command -v helm &> /dev/null; then
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
  echo "Helm est déjà installé"
fi

# Ajouter le dépôt Helm de Jenkins s'il n'est pas déjà ajouté
if ! helm repo list | grep -q "jenkins"; then
  helm repo add jenkins https://charts.jenkins.io
  helm repo update
else
  echo "Le dépôt Helm de Jenkins est déjà ajouté"
fi

# Créer un namespace pour Jenkins seulement s'il n'existe pas
if ! kubectl get namespace jenkins &> /dev/null; then
  kubectl create namespace jenkins
else
  echo "Le namespace jenkins existe déjà"
fi

# Déployer Jenkins via Helm seulement s'il n'est pas déjà déployé
if ! helm ls -n jenkins | grep -q "jenkins"; then
  helm upgrade jenkins jenkins/jenkins --namespace jenkins \
    --set controller.nodeSelector."kubernetes\.io/role"=worker \
    --set controller.serviceType=LoadBalancer
else
  echo "Jenkins est déjà déployé dans le namespace jenkins"
fi

# Ajouter des permissions à Jenkins seulement si le clusterrolebinding n'existe pas
if ! kubectl get clusterrolebinding jenkins-admin &> /dev/null; then
  kubectl create clusterrolebinding jenkins-admin --clusterrole=cluster-admin --serviceaccount=jenkins:default
else
  echo "Le clusterrolebinding jenkins-admin existe déjà"
fi