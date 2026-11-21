#!/usr/bin/env bash

set -euo pipefail

# Namespaces
NAMESPACES=("kube-dev" "kube-storage" "kube-monitoring")

# If arguments are provided to the script, use those instead:
if [ "$#" -gt 0 ]; then
  NAMESPACES=("$@")
fi

# Ensure kubectl is installed and reachable
if ! command -v kubectl &> /dev/null; then
  echo "Error: kubectl command could not be found." >&2
  exit 1
fi

echo "--- Starting namespace creation ---"

for ns in "${NAMESPACES[@]}"; do
  # Basic check for empty strings
  if [[ -z "$ns" ]]; then
    continue
  fi

  echo "Processing namespace: '${ns}'..."

  kubectl create namespace "${ns}" --dry-run=client -o yaml | kubectl apply -f -
done

echo "--- Completed. Listing all created namespaces ---"
kubectl get namespaces