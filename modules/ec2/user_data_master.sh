#!/bin/bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-name=master --token=${K3S_TOKEN}" sh -