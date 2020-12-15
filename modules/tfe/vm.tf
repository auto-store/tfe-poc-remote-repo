resource "google_compute_instance_template" "main" {
  name_prefix    = "${var.namespace}-tfe-template-"
  machine_type   = var.instance_config.machine_type
  region         = var.region
  can_ip_forward = true

  disk {
    source_image = data.google_compute_image.image.self_link
    auto_delete  = true
    boot         = true
    disk_size_gb = var.instance_config.boot_disk_size
    disk_type    = var.instance_config.type
  }

  service_account {
    scopes = ["logging-write", "monitoring-write"]
  }

  network_interface {
    subnetwork = var.networking_config.subnetwork

    dynamic "access_config" {
      for_each = true ? ["one"] : []
      content {}
    }
  }

  # TODO: logic to only set user-data or metadata_startup_script
  metadata = {
    # user-data* -> Cloud Init Supported OS
    user-data          = var.cloud-init.content
    user-data-encoding = var.cloud-init.encoding
    google-monitoring-enable = 1
    google-logging-enable = 1
  }

  # start up script -> Non Cloud Init Supported OS
  metadata_startup_script = var.startup_script

  labels = var.labels

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "main" {
  name = "${var.namespace}-tfe-group-manager"

  base_instance_name = "${var.namespace}-tfe-vm"
  region             = var.region

  version {
    instance_template = google_compute_instance_template.main.self_link
  }

  target_size = 1

  named_port {
    name = "https"
    port = 443
  }

  named_port {
    name = "console"
    port = 8800
  }

  dynamic "auto_healing_policies" {
    for_each = var.auto_healing_enabled ? ["one"] : []
    content {
      health_check      = google_compute_health_check.tfe-health.self_link
      initial_delay_sec = 600
    }
  }
}

resource "google_compute_health_check" "tfe-health" {
  name                = "${var.namespace}-tfe-health-check"
  check_interval_sec  = 120
  timeout_sec         = 20
  healthy_threshold   = 2
  unhealthy_threshold = 10

  https_health_check {
    port         = 443
    request_path = "/_health_check"
  }
}
