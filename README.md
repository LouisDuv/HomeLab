# HomeLab

**Author**      
Louis DUVANEL       
**Objective**       
Learning about DevOps concepts by building my own platform of services 

---

### In-coming

- Bench of test to ensure the cluster is healthy and ready-to use 
- Changing functionalities to be customizable
- Add k9s installation as UI/UX

## Manager your k3s cluster

### Set security (Optional)

You have the possibility to use efficiently the vault management proposed by Ansible. Here is some steps to save your passwords and other sensitive data

> e.g : Ansible required `sudo` privilege. You don't want to write your password for every execution and for every machine. There is also a big risk to save machine's password somewhere in your code. The following steps help you is this kind of use cases.

```bash
# Go to k3s-server dir
cd ./Infrastructure/k3s-server

# Source useful functions
./init.sh

# Create secret file to store data
mkdir ./inventory/host_vars/[your_node]
touch ./inventory/host_vars/[your_node]/secret.yaml

# write data in key : value pair

# create a key vault
[your_key] > ./vault/[your_node]-vault-key.txt

# Encrypt your data
vault_encrypt [your_node]

# Decrypt your data
vault_decrypt [your_node]
```

To allow Ansible Controller to collect these data, we need to add their references inside configuration file `ansible.cfg`

```ini
vault_identity_list = [your_node]@vault/.[your_node]-vault-key.txt, [your_node_2]@vault/.[your_node_2]-vault-key.txt,...
```

### Manager the Master Node

The following steps install the control-plane only (master node) only. By default, the control plane is the local node.

```bash
# Go to k3s-server dir
cd ./Infrastructure/k3s-server

# Download packages
./init.sh

# To install the control-plane
./create.sh

# To delete the control-plane
./delete.sh

# Get a view installation and deletion of the cluster
cat $K3S_INSTALL_LOG
cat $K3S_DELETION_LOG
```

### Manage Agent Nodes

Agent nodes can be used for higher redundancy of data and as an expension of ressources like CPU and RAM.

**Requirements**
- A Master Node is set as a Controll-Plane in your K3S cluster (following past script)
- Master Node can SSH agent node
- Fill credentials in secret encrypted (optional) file or in host file (e.g at ./Infrastructure/k3s-server/inventory/hosts.yaml)

```bash
# Go to k3s-server dir
cd ./Infrastructure/k3s-server

# After fullfilling all requirements, execute this script for your agent node to join master node
./create-agent.sh

# Separata your agent from your cluster
./delete-agent.sh
```
