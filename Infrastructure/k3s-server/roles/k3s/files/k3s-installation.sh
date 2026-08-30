#!/bin/bash

echo "[1/2] K3s installation"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
    --disable servicelb \
    --write-kubeconfig-mode 644 \
    --node-ip 192.168.29.1 \
    --node-name master-node \
" sh -s -

echo "[2/2] Installation is successfull"