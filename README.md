# Terraform-RNCP


       +-------------------------------------------------------------+
       |                       AWS Cloud                             |
       |                                                             |
       |  +-------------------------+       +---------------------+  |
       |  |     Public Subnets      |       |    Private Subnets  |  |
       |  |                         |       |                     |  |
       |  | +---------------------+ |       | +-----------------+ |  |
       |  | |      ALB / NLB      | |       | |     EKS Nodes   | |  |
       |  | |    (Load Balancer)  | |       | |                 | |  |
       |  | +---------------------+ |       | +-----------------+ |  |
       |  |                         |       |                     |  |
       |  | +---------------------+ |       | +-----------------+ |  |
       |  | |     Traefik Ingress   |<----->| |   Jenkins Pod   | |  |
       |  | +---------------------+ |       | |                 | |  |
       |  |                         |       | +-----------------+ |  |
       |  +-------------------------+       +---------------------+  |
       |                                                             |
       |  +----------------------------+    +---------------------+  |
       |  |        IAM Roles           |    |      ACM Certs      |  |
       |  |  - EKS Cluster Role        |    | - SSL Certificates  |  |
       |  |  - Traefik Role            |    |                     |  |
       |  +----------------------------+    +---------------------+  |
       +-------------------------------------------------------------+


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

## ALB (Application Load Balancer) / NLB (Network Load Balancer)

### Description : 
- Load Balancers gérés par AWS pour répartir le trafic entrant vers les services Kubernetes.
### Utilité : 
- Répartit le trafic entrant vers les nœuds EKS via Traefik Ingress Controller.

## IAM Roles and Policies

### Utilité: 
Gère les permissions et les accès pour les différentes ressources AWS.
### Composants:
- EKS Role: Permet aux nœuds EKS d'interagir avec d'autres services AWS.
- KMS Policy: Autorise la création et la gestion de clés KMS.
- ACM Policy: Autorise l'accès aux certificats ACM.
- Traefik Role : Permissions pour Traefik pour gérer les ressources AWS nécessaires (comme les Load Balancers).

## S3 Buckets

### Utilité: 
Stocke les sauvegardes des bases de données et des configurations critiques.
### Composants:
- etcd Backup Bucket
- Postgres Backup Bucket
- Elasticsearch Backup Bucket

## Traefik Ingress Controller

### Description : 
- Un contrôleur Ingress qui gère les routages d'entrée pour les services Kubernetes.
### Utilité : 
- Gère le routage du trafic vers les services au sein du cluster Kubernetes, en fournissant des fonctionnalités telles que le middleware, la gestion SSL, et  les règles de routage avancées.

## Jenkins Pod

### Description : 
- Un conteneur Jenkins déployé sur le cluster EKS.
### Utilité : 
- Fournit des services CI/CD pour automatiser les processus de développement, de test et de déploiement des applications.

## ACM (AWS Certificate Manager)

### Utilité: 
Gère les certificats SSL/TLS pour sécuriser les communications entre les clients et les services.
### Composants:
- ACM Certificate: Certificat SSL