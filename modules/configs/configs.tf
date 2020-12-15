resource "random_string" "console_password" {
  length  = 24
  special = false
}

resource "random_string" "encrypt_password" {
  length  = 24
  special = false
}

data "template_file" "replicated_config" {
  template = file("${path.module}/templates/replicated/replicated.conf")

  vars = {
    airgap           = false
    hostname         = var.hostname
    console_password = random_string.console_password.result
    release_sequence = var.release_sequence
  }
}

data "template_file" "replicated_tfe_config" {
  template = file("${path.module}/templates/replicated/replicated-tfe.conf")

  vars = {
    hostname        = var.hostname
    enc_password    = random_string.encrypt_password.result
    pg_netloc       = var.postgres_config.netloc
    pg_dbname       = var.postgres_config.dbname
    pg_user         = var.postgres_config.user
    pg_password     = var.postgres_config.password
    pg_extra_params = var.postgres_config.extra_params
    gcs_bucket      = var.object_store_config.bucket
    gcs_credentials = var.object_store_config.credentials
    gcs_project     = var.object_store_config.project
  }
}
