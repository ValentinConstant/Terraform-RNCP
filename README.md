# Terraform-RNCP

## VPC
- Bloc CIDR du VPC : 10.0.0.0/16
- Région : eu-west-3
## Sous-réseaux
### Sous-réseaux publics :
- Sous-réseau 1 : 10.0.1.0/24 dans la zone de disponibilité eu-west-3a
- Sous-réseau 2 : 10.0.2.0/24 dans la zone de disponibilité eu-west-3b
- Sous-réseau 3 : 10.0.3.0/24 dans la zone de disponibilité eu-west-3c
### Sous-réseaux privés :
- Sous-réseau 1 : 10.0.4.0/24 dans la zone de disponibilité eu-west-3a
- Sous-réseau 2 : 10.0.5.0/24 dans la zone de disponibilité eu-west-3b
- Sous-réseau 3 : 10.0.6.0/24 dans la zone de disponibilité eu-west-3c
## Bastion Host (Hôte Bastion)
- Type d'instance : t3.micro
- Sous-réseau : Sous-réseau public dans eu-west-3a
- Rôle : Fournit un accès SSH aux instances dans les sous-réseaux privés.
## Noeud Master
- Type d'instance : t3.medium
- Sous-réseau : Sous-réseau privé dans eu-west-3a
- AMI : ami-0a91cd140a1fc148a (exemple)
## Groupe d'Auto-scaling (ASG) pour les noeuds worker
Template de lancement :
- Type d'instance : t3.medium
- AMI : ami-0a91cd140a1fc148a (exemple)
- Script User Data : Script pour rejoindre le cluster K3s
- Capacité souhaitée : 3 instances
- Taille minimale : 1 instance
- Taille maximale : 5 instances
- Sous-réseaux : Sous-réseaux privés dans eu-west-3a, eu-west-3b, et eu-west-3c
## Load Balancers (Équilibreurs de charge)
- Pour le noeud master : Assure la haute disponibilité et équilibre le trafic vers le noeud master.
- Pour les noeuds worker : Équilibre le trafic à travers les noeuds worker du groupe d'auto-scaling.
## AWS Secrets Manager
- Rôle : Stocke les secrets tels que le PAT GitHub, les identifiants PostgreSQL, le mot de passe admin de Jenkins, et le token K3s.
## Buckets S3
Pour les sauvegardes :
- Sauvegardes PostgreSQL
- Sauvegardes Elasticsearch
- Sauvegardes ETCD
## Applications Déployées dans le Cluster K3s
### Application :
- Namespace : **dev** et **prod**
- Rôle : Application 
- Configuration : Déployé avec helm via pipeline CI/CD Jenkins
### Jenkins :
- Namespace : default
- Rôle : Serveur CI/CD connecté à GitHub
## Connectivité Réseau
- Client externe : Se connecte à l'hôte Bastion.
- Hôte Bastion : Fournit un accès SSH sécurisé au noeud Master et aux noeuds Worker dans les sous-réseaux privés.
- Noeud Master : Communique avec les noeuds Worker via le plan de contrôle K3s.
- Noeuds Worker : Gérés par le groupe d'auto-scaling pour assurer la haute disponibilité et la scalabilité.
## Rôles IAM
### Rôle IAM pour les instances EC2 :
- Nom du rôle : ec2-role
- Politique d'assumer le rôle : Permet à EC2 d'assumer le rôle
- Politique d'accès : Accès à Secrets Manager et S3
## Groupes de Sécurité (Security Groups)
### Groupe de sécurité pour le Bastion Host :
- Nom : bastion-sg
- Description : Security group for the bastion host
- Règles Ingress : Permet l'accès SSH (port 22) depuis n'importe quelle IP
- Règles Egress : Permet tout le trafic sortant
### Groupe de sécurité pour les instances EC2 :
- Nom : ec2-sg
- Description : Security group for the EC2 instances
- Règles Ingress :
    - Permet l'accès SSH depuis le Bastion Host (port 22)
    - Permet le trafic sur le port K3s (6443) depuis les sous-réseaux privés
    - Permet le trafic entre nœuds sur tous les ports
- Règles Egress : Permet tout le trafic sortant



# Déploiement :

## Tâches préalables :
- Génération du token k3s :
```export K3S_TOKEN=$(openssl rand -base64 32)```
- Stockage du token dans AWS secret manager
```aws secretsmanager create-secret --name k3s/token --secret-string "{\"token\":\"$K3S_TOKEN\"}"```
- Stokage de la même manière des autres secrets :
    - GitHub PAT
    - PostgreSQL Credentials
    - Jenkins Admin Password
    - Clé SSH pour l'accès au Bastion et EC2
