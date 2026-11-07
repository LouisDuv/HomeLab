# Infrastructure Basic Tools & Core Services

This directory orchestrates the automated provisioning and deployment of baseline platform services for the Kubernetes cluster. 

Using **Helm** and **custom/service Helm charts**, these components establish the essential foundational layers required before deploying higher-level workloads, covering container image hosting, vulnerability scanning, observability, and persistent storage/database backends.

---

## 📦 Orchestrated Services

The stack is composed of the following core modules:

* **Traefik (`traefik/`)**: A vendor-neutral, OCI-compliant, lightweight container image registry running natively on Kubernetes to host internal container artifacts and images.
* **Zot Registry (`zot-registry/`)**: A vendor-neutral, OCI-compliant, lightweight container image registry running natively on Kubernetes to host internal container artifacts and images.

More to come !

---

## 🏗️ Deployment Architecture & Standards

All services are packaged as local custom Helm charts (or vendor charts with pinned custom override values):

* **Deploy basic namespaces**: Execute the bash file to create automatically basic namespaces
  ```bash
  cd Infrastructure/basic-tools
  sudo chmod +x ./init-namespace.sh
  ./init-namespace.sh
  ```
* **Declarative Configurations**: Each service directory maintains its `values.yaml` 
* **Dry-Run & Validation**: Manifests can be inspected locally prior to cluster application using `helm template` without requiring live deployments:
  ```bash
  helm template <release-name> ./<chart-dir> -f ./<chart-dir>/values.yaml
  ```