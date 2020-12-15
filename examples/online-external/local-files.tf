# TODO: Remove this in Production
# Optionally copy the rendered files locally for debugging purposes

# SSH Keys for access the instances
resource "local_file" "admin-pem" {
  filename        = "./keys/admin_rsa.pem"
  content         = tls_private_key.admin.private_key_pem
  file_permission = "600"
}

resource "local_file" "admin-pub" {
  filename        = "./keys/admin_rsa.pub"
  content         = tls_private_key.admin.public_key_openssh
  file_permission = "600"
}

# TLS Files
resource "local_file" "tls-key" {
  filename = "./keys/tls.key"
  content  = module.tls.key
}

resource "local_file" "tls-certificate" {
  filename = "./keys/tls.cert"
  content  = module.tls.cert
}

# Start Up Scripts and Config
resource local_file replicated-conf {
  filename = "./.terraform/replicated-conf.json"
  content  = module.configs.replicated_config
}

resource local_file replicated-tfe-conf {
  filename = "./.terraform/replicated-tfe-conf.json"
  content  = module.configs.replicated_tfe_config
}

resource local_file startup_script {
  filename = "./.terraform/startup_script.sh"
  content  = module.configs.startup_script
}
