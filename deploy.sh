#!/bin/bash

terraform init -upgrade

terraform apply -target=module.vpc -target=module.security_groups -target=module.iam -target=module.s3 -target=module.eks -target=module.alb -auto-approve

terraform apply -target=module.jenkins -target=module.traefik -auto-approve
