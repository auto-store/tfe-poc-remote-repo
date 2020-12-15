resource "google_compute_network" "tfe_vpc" {
  name                    = "${var.namespace}-vpc"
  description             = "Terraform Enterprise VPC Network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tfe_subnet" {
  name          = "${var.namespace}-subnet"
  ip_cidr_range = var.subnet_range
  region        = var.region
  network       = google_compute_network.tfe_vpc.self_link
}

resource "google_compute_router" "router" {
  name    = "${var.namespace}-router"
  region  = var.region
  network = google_compute_network.tfe_vpc.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.namespace}-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}


resource "google_compute_firewall" "tfe" {
  name    = "${var.namespace}-firewall"
  network = google_compute_network.tfe_vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = concat(["22", "80", "443", "6443", "8800", "23010"], var.firewall_ports)
  }

  source_ranges = var.ip_allow_list
}

resource "google_compute_firewall" "lb-healthchecks" {
  name          = "${var.namespace}-lb-healthcheck-firewall"
  network       = google_compute_network.tfe_vpc.name
  source_ranges = concat([google_compute_subnetwork.tfe_subnet.ip_cidr_range], var.healthcheck_ips)

  allow {
    protocol = "tcp"
  }
}
