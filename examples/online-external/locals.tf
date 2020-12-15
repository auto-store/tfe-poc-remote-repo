locals {
  hostname = join(".", [var.subdomain, var.domain])
}

# Generate public/private SSH keys for admin
resource "tls_private_key" "admin" {
  algorithm = "RSA"
}
