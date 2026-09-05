# HomeLab

**Author**      
Louis DUVANEL       
**Objective**       
Learning about DevOps concepts by building my own platform of services 

---

### In-coming

- Agent nodes attachment script
- Bench of test to ensure the cluster is healthy and ready-to use 

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

### Create the control-plane

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