variable "hosts" {
    default = {
        "127.0.0.2" = "local-host"
        "tailscale" = "VPN"
    }
}

resource "null_resource" "node1" {
    for_each = var.hosts
    provisioner "local-exec" {
        command = "echo '${each.key} => ${each.value}' >> hosts.txt"
    }
}