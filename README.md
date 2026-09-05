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