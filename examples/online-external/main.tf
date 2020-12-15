terraform {
  backend "remote" {
    organization = "emea-se-playground-2019"

    workspaces {
      name = "tharris-tfe-poc"
    }
  }
}


module "tls" {
  // source = "../../modules/tls-acme" # Let's Encrypt
  source   = "../../modules/tls-private" # Self-Signed
  domain   = var.domain
  hostname = local.hostname

  // dns_challenge_type = "gcloud"

  # Challenge types here: https://www.terraform.io/docs/providers/acme/dns_providers/index.html
  # You MUST set the ENV variables for this to work with Let's Encrypt
}

resource "google_compute_ssl_certificate" "default" {
  name_prefix = "tfegcp-cert"
  description = "ACME generated TLS for ${local.hostname}"
  private_key = module.tls.key  # local_file.tls-key.content
  certificate = module.tls.cert # local_file.tls-certificate.content

  lifecycle {
    create_before_destroy = true
  }
}

module "networking" {
  source = "../../modules/networking"

  namespace = var.namespace
  region    = var.region
}

module "external-services" {
  source = "../../modules/external-services"

  namespace   = var.namespace
  network     = module.networking.config.network
  credentials = var.credentials
  labels      = var.labels
}

module "configs" {
  source = "../../modules/configs"

  license_file        = var.tfe_license_file
  hostname            = local.hostname
  postgres_config     = module.external-services.postgres_config
  object_store_config = module.external-services.object_storage_config
  add_bash_debug      = true
  add_gcp_logging     = true
}

module "tfe" {
  source = "../../modules/tfe"

  namespace      = var.namespace
  region         = var.region
  startup_script = module.configs.startup_script
  # auto_healing_enabled = false

  instance_config = {
    machine_type   = "n1-standard-2"
    image_family   = "rhel-7"
    image_project  = "gce-uefi-images"
    boot_disk_size = 50
    type           = "pd-ssd"
  }

  networking_config = {
    subnetwork = module.networking.config.subnetwork
    network    = module.networking.config.network
  }
  labels = var.labels
}

module "load-balancer" {
  source = "../../modules/load-balancer"

  namespace      = var.namespace
  instance_group = module.tfe.instance_group
  cert           = google_compute_ssl_certificate.default.self_link
}
