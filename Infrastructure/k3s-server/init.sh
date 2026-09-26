#!/bin/bash

echo "[0/2] Sourcing helpers"
source ./helpers/functions.sh #TODO: Source correctly functions to do not do it everytime 
source ./helpers/vars.sh


echo "[1/2] Primary package install"
#!/usr/bin/env bash

echo "==> Step 1: Checking uv installation..."
if ! has_cmd uv; then
  echo "uv is not installed. Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

  if ! has_cmd uv; then
    echo "ERROR: Failed to locate 'uv' after installation." >&2
    return 1 2>/dev/null || exit 1
  fi
  echo "uv installed successfully: $(uv --version)"
else
  echo "uv is already installed: $(uv --version)"
fi

echo "==> Step 2: Checking uv.lock..."
if [ ! -f "uv.lock" ]; then
  echo "No uv.lock found. Initializing project and locking ansible==10.7.0..."
  if [ ! -f "pyproject.toml" ]; then
    uv init --no-workspace .
  fi
  uv add "ansible==10.7.0"
  uv lock
else
  echo "Found existing uv.lock."
fi

echo "==> Step 3: Syncing virtual environment from uv.lock..."
# uv sync automatically creates .venv if missing and installs exactly what is in uv.lock
uv sync

echo "==> Step 4: Activating .venv in the current session..."
if [ -f ".venv/bin/activate" ]; then
  # shellcheck source=/dev/null
  source .venv/bin/activate
  echo "Activated environment: $VIRTUAL_ENV"
else
  echo "ERROR: .venv/bin/activate not found." >&2
  return 1 2>/dev/null || exit 1
fi

echo "==> Step 5: Verifying Ansible installation..."
if ! has_cmd ansible; then
  echo "ERROR: ansible binary not found in PATH." >&2
  return 1 2>/dev/null || exit 1
fi

INSTALLED_VERSION=$(python -c "import ansible; print(ansible.__version__)" 2>/dev/null)
echo "SUCCESS: Ansible $INSTALLED_VERSION is ready in .venv"
echo "Ansible path: $(which ansible)"

# activate .venv in current shell context
echo "Activating venv..."

echo "[2/2] Changing privilege for executing scripts"
chmod +x ./create.sh
chmod +x ./delete.sh
echo ""
echo "Two options are now possible :"
echo "  - Create the K3s cluster with : ./create.sh"
echo "  - Destroy the existing one : ./delete.sh"



