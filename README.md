# Terraform-RNCP

## VPC (Virtual Private Cloud)

### Utilité: 
Fournit un réseau virtuel isolé pour déployer les ressources AWS.
### Composants:
- CIDR Block: 10.0.0.0/16 (par exemple).

## Public Subnets

### Utilité: 
Héberge des ressources accessibles depuis l'Internet public, comme le Load Balancer (ALB) et le NAT Gateway.
### Composants:
- Subnet 1: 10.0.1.0/24
- Subnet 2: 10.0.2.0/24

## Private Subnets

### Utilité: 
Héberge des ressources internes non accessibles directement depuis l'Internet public, comme les nœuds EKS.
### Composants:
- Subnet 1: 10.0.4.0/24
- Subnet 2: 10.0.5.0/24

## NAT Gateway

### Utilité: 
Permet aux instances dans les subnets privés de communiquer avec l'Internet tout en restant non accessibles depuis l'extérieur.
### Localisation: 
Public Subnet 2.

## EKS Cluster (Elastic Kubernetes Service)

### Utilité: 
Fournit un environnement Kubernetes managé pour déployer et gérer des applications conteneurisées.
### Composants:
- EKS Control Plane: Géré par AWS.
- EKS Nodes: Instances EC2 dans les subnets privés.

## IAM Roles and Policies

### Utilité: 
Gère les permissions et les accès pour les différentes ressources AWS.
### Composants:
- EKS Role: Permet aux nœuds EKS d'interagir avec d'autres services AWS.
- KMS Policy: Autorise la création et la gestion de clés KMS.
- ACM Policy: Autorise l'accès aux certificats ACM.

## S3 Buckets

### Utilité: 
Stocke les sauvegardes des bases de données et des configurations critiques.
### Composants:
- etcd Backup Bucket
- Postgres Backup Bucket
- Elasticsearch Backup Bucket

## Jenkins

### Utilité: 
Serveur CI/CD utilisé pour automatiser les tâches de déploiement et de test de l'application
### Localisation: 
Déployé sur le cluster EKS.

## ACM (AWS Certificate Manager)

### Utilité: 
Gère les certificats SSL/TLS pour sécuriser les communications entre les clients et les services.
### Composants:
- ACM Certificate: Certificat SSL