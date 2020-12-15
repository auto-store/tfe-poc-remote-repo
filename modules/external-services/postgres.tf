resource "random_pet" "postgres" {
  length = 2
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = "${var.namespace}-private-ip-address"
  purpose       = "VPC_PEERING"
  address       = "10.200.1.0"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = var.network
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network = var.network
  service = "servicenetworking.googleapis.com"

  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "tfe" {
  provider         = google-beta
  name             = "${var.namespace}-tfe-${random_pet.postgres.id}"
  database_version = "POSTGRES_9_6"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier              = var.postgres_instance_config.machinetype
    availability_type = var.postgres_instance_config.availability_type
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
      # require_ssl     = true #TODO: lock down to SSL
    }

    backup_configuration {
      enabled    = var.postgres_instance_config.backup_start_time == "" ? false : true
      start_time = var.postgres_instance_config.backup_start_time
    }

    user_labels = var.labels
  }
}

resource "random_string" "postgres_password" {
  length  = 20
  special = false
}

resource "google_sql_database" "tfe" {
  name     = var.postgres_instance_config.dbname
  instance = google_sql_database_instance.tfe.name
}

resource "google_sql_user" "tfe" {
  name     = var.postgres_instance_config.username
  instance = google_sql_database_instance.tfe.name

  password = random_string.postgres_password.result
}
