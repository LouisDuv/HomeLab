#!/usr/bin/env bash
set -euo pipefail

DEFAULT_OCI_TARGET="oci://registry.homelab.com/charts"

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <repo_name> <chart_name> <repo_url> [chart_version] [oci_target]"
  echo "Exemples :"
  echo "  $0 traefik traefik https://traefik.github.io/charts"
  echo "  $0 traefik traefik https://traefik.github.io/charts 34.4.0"
  echo "  $0 traefik traefik https://traefik.github.io/charts 34.4.0 oci://registry.homelab.com/custom"
  exit 1
fi

REPO_NAME="$1"
CHART_NAME="$2"
REPO_URL="$3"
CHART_VERSION="${4:-}"
OCI_TARGET="${5:-$DEFAULT_OCI_TARGET}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "-> Ajout/mise à jour du dépôt Helm '$REPO_NAME' ($REPO_URL)..."
helm repo add "$REPO_NAME" "$REPO_URL" --force-update
helm repo update "$REPO_NAME"

PULL_ARGS=(--destination "$TMP_DIR")
if [[ -n "$CHART_VERSION" ]]; then
  PULL_ARGS+=(--version "$CHART_VERSION")
  echo "-> Téléchargement de '$REPO_NAME/$CHART_NAME' (version $CHART_VERSION)..."
else
  echo "-> Téléchargement de '$REPO_NAME/$CHART_NAME' (dernière version)..."
fi

helm pull "$REPO_NAME/$CHART_NAME" "${PULL_ARGS[@]}"

TGZ_FILE=$(find "$TMP_DIR" -maxdepth 1 -name "*.tgz" | head -n 1)

if [[ -z "$TGZ_FILE" ]]; then
  echo "Error : no archive .tgz found after loading"
  exit 1
fi

echo "-> Push of '$(basename "$TGZ_FILE")' vers '$OCI_TARGET' (--plain-http)..."
helm push "$TGZ_FILE" "$OCI_TARGET" --plain-http

echo "Finished : $(basename "$TGZ_FILE") pushed successfull to $OCI_TARGET"