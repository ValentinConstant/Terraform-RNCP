#!/bin/bash
curl -sfL https://get.k3s.io | K3S_TOKEN=${K3S_TOKEN} sh -s - server --node-name master
