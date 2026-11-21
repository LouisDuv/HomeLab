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

To ensure reproducible deployments and avoid relying on public repositories (downtime, removed versions, or paywall transitions), Helm charts are mirrored to the internal OCI registry (`oci://registry.homelab.com/charts`).

### How It Works

* **Immutable charts in the OCI registry:** `.tgz` archives are pulled at a pinned version from upstream and pushed to the private registry using `mirror-chart.sh`.
* **Lightweight Git repository:** Only override files (`values.yaml`) and deployment configurations are versioned in Git.
* **Deep-merge overrides:** During deployment, Helm automatically merges the keys defined in the local `values.yaml` with the mirrored chart's default values.
* **Specific charts:** Specific charts are customed locally to adapt templates

### Usage

```bash
# 1. Mirror a chart to the internal registry
./mirror-chart.sh <repo_name> <chart_name> <repo_url> [version]

# 2. Deploy while overriding only the required values
helm upgrade --install <release> oci://[registry.homelab.com/charts/](https://registry.homelab.com/charts/)<chart_name> \
  --version <version> \
  --plain-http \
  -f values.yaml