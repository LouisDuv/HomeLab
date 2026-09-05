# Global

is_package_installed() {
    local package_name="$1"

    if command -v dpkg-query &> /dev/null; then
        dpkg-query -W -f='${Status}' "$package_name" 2>/dev/null | grep -q "install ok installed"
        return $?
    else
        command -v "$package_name" &> /dev/null
        return $?
    fi
}

# Vault-Management

vault_decrypt() {
    # $1 : hostname
    local hostname="$1"
    local key_file="$(pwd)/vault/.${hostname}-vault-key.txt"
    local secrets_file="$(pwd)/inventory/host_vars/${hostname}/secret.yaml"

    # Check if the vault key file exists
    if [ -f "$key_file" ]; then
        echo "[INFO] Vault key file found: $key_file"
    else
        echo "[WARNING] Vault key file not found at: $key_file"
    fi

    # Check if the secrets file exists
    if [ -f "$secrets_file" ]; then
        echo "[INFO] Secrets file found: $secrets_file"
    else
        echo "[ERROR] Secrets file not found at: $secrets_file"
        echo "[ERROR] Please create an empty file named secret.yaml and try again"
        return 1
    fi

    echo "[INFO] Decrypting $secrets_file..."
    ansible-vault decrypt --vault-id "${hostname}@${key_file}" "${secrets_file}"
    echo "[WARNING] Do not forget to encrypt it again after utilization with vault_encrypt"
}

vault_encrypt() {
    # $1 : hostname
    local hostname="$1"
    local key_file="$(pwd)/vault/.${hostname}-vault-key.txt"
    local secrets_file="$(pwd)/inventory/host_vars/${hostname}/secret.yaml"

    # Check if the vault key file exists
    if [ -f "$key_file" ]; then
        echo "[INFO] Vault key file found: $key_file"
    else
        echo "[WARNING] Vault key file not found at: $key_file"
        return 1
    fi

    # Check if the secrets file exists
    if [ -f "$secrets_file" ]; then
        echo "[INFO] Secrets file found: $secrets_file"
    else
        echo "[ERROR] Secrets file not found at: $secrets_file"
        echo "[ERROR] Please create an empty file named secret.yaml and try again"

        return 1
    fi
    echo "[INFO] Encrypting $secrets_file..."
    ansible-vault encrypt --encrypt-vault-id "${hostname}" --vault-id "${hostname}@${key_file}" "${secrets_file}"    
    echo "[INFO] Your file is now secured"
}
