# Terraform-RNCP
Ce repository concerne l'infrastructure de l'application DATA-AIR.
Dans une optique d'isolation de l'applicatif et de l'infrastructure, le présent repository ne comporte pas le code source de l'application. Pour accéder à celui-ci, voir : https://github.com/kbnhvn/DevOps-RNCP

## Diagramme de l'infrastructure :
![alt text](https://private-user-images.githubusercontent.com/22301011/346141595-09051795-9fdb-40db-b50f-a2625e2ec2f2.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjAxODczNjEsIm5iZiI6MTcyMDE4NzA2MSwicGF0aCI6Ii8yMjMwMTAxMS8zNDYxNDE1OTUtMDkwNTE3OTUtOWZkYi00MGRiLWI1MGYtYTI2MjVlMmVjMmYyLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDA3MDUlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwNzA1VDEzNDQyMVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTJhZjdlMzUwNDk1ZTY2NWQwNmFlNDhjMTE3YjQ1MzM1MWMwZTJkY2NmOTFkZWQ3YTc3MWNjZWM4ZDIxYjc0ZjImWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.KfW2LtG28Pc6d_plahMc1PbrgFZ-pJM-WqhbI5s0fN8)

Ce diagramme illustre l'architecture détaillée de l'infrastructure AWS déployée pour l’application DATA-AIR. Cette configuration montre comment chaque composant est intégré pour former un système sécurisé et fonctionnel : 

### Région AWS et VPC : 
Toute l'infrastructure est déployée dans la région AWS **eu-west-3** et encapsulée dans un **Virtual Private Cloud (VPC)** avec un bloc **CIDR de 10.0.0.0/16**, fournissant un environnement réseau isolé pour les ressources AWS.
### Internet Gateway (IGW) : 
L'IGW permet aux instances du VPC de se connecter à Internet. Il agit comme un point de sortie pour le trafic réseau **depuis les instances du VPC vers Internet**. 
### Subnets et NAT Gateways : 
Trois sous-réseaux publics sont configurés dans **trois zones de disponibilité distinctes (eu-west-3a, eu-west-3b et eu-west-3c)**. Chaque sous-réseau public est associé à sa propre NAT Gateway, permettant aux instances des sous-réseaux privés de se connecter à Internet tout en restant protégées des connexions entrantes non sollicitées. 
### EKS Cluster et Node Groups : 
Le cluster EKS gère les applications conteneurisées en orchestrant **le déploiement, la mise à l'échelle, et les opérations des conteneurs**. Les **groupes de nœuds**, constitués d'instances EC2, sont répartis sur les sous-réseaux privés pour une meilleure performance et sécurité. Les groupes **d'auto-scaling** associés assurent une adaptabilité en fonction de la charge de travail. 
### Load Balancer : 
Un Classic Load Balancer est positionné en amont du cluster EKS, facilitant la distribution et l'**équilibrage du trafic entrant vers les microservices de l'application**. 
### EFS (Elastic File System) : 
EFS fournit un **système de fichiers partagé et persistant**, accessible par les nœuds du cluster EKS. Les **cibles de montage EFS** sont déployées dans **chaque zone de disponibilité**, permettant aux instances EC2 de monter le système de fichiers de manière **sécurisée et efficace**. 
### S3 (Simple Storage Service) : 
S3 est utilisé pour le stockage d'objets et les **sauvegardes des données critiques**. Les données sont stockées de manière durable et peuvent être facilement récupérées en cas de besoin. Cette architecture assure une infrastructure scalable, sécurisée et hautement disponible pour l'application DATA-AIR, tout en offrant des solutions de stockage robustes et flexibles avec EFS et S3.

## Automatisation du déploiement :

Cette infrastructure utilise la solution d'Infrastructure as Code **Terraform** afin d'automatiser le déploiement de l'infrastructure. Le code HCL utilisé par Terraform est ici organisé en différents modules dans une soucis de clarté et maintenabilité :

### Module VPC :
Déclaration du **VPC**, des **sous-réseaux**, des **NAT gateway**, **Internet Gateway** et **tables de routage**.

### Module IAM :
Déclaration des différents **roles IAM** et leurs **policies**.

### Module EKS :
Définition du **cluster Kubernetes EKS** ansi que des différents **noeuds**, types d'**instanaces** et **autoscalling group**.

### Module STORAGE :
Définition du **stockage EFS**, avec **mount targets** et **access point**, pour le stockage persistant nécéssaires au StatefulSets (bases de données de l'application), aisnsi que les **buckets S3** pour les sauvegardes.

## Déploiement continu :

Le déploiement continu de cette infrastructure utilise un workflow GitHub Actions et permet le lancement des commandes **init/plan/apply de Terraform** pour le déploiement de l'infrastructure, la configuration de kubectl, kubeconfig pour la gestion du cluster, ainsi que l'installation de Helm et la configuration des persistent Volumes.



