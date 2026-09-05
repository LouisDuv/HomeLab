#!/bin/bash

echo "[0/2] Sourcing helpers"
source ./helpers/functions.sh
source ./helpers/vars.sh


echo "[1/2] Primary package install"
if is_package_installed "ansible"; then
    echo "Ansible is already present"
else
    echo "Ansible is not installed."
    sudo apt install -y ansible 
fi

echo "[2/2] Changing privilege for executing scripts"
sudo chmod +x ./create.sh
sudo chmod +x ./delete.sh
echo ""
echo "Two options are now possible :"
echo "  - Create the K3s cluster with : ./create.sh"
echo "  - Destroy the existing one : ./delete.sh"

