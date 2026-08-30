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