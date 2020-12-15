resource "google_compute_backend_service" "application" {
  name        = "${var.namespace}-application"
  port_name   = "https"
  protocol    = "HTTPS"
  timeout_sec = 60

  backend {
    description = "TFE Application"
    group       = var.instance_group
  }

  health_checks   = [google_compute_health_check.application.self_link]
  security_policy = google_compute_security_policy.security-policy-1.self_link
}

resource "google_compute_health_check" "application" {
  name               = "${var.namespace}-application-healthcheck"
  check_interval_sec = 5
  timeout_sec        = 4

  https_health_check {
    port         = 443
    request_path = "/_health_check"
  }
}

resource "google_compute_security_policy" "security-policy-1" {
  name        = "${var.namespace}-cloudarmor-policy-1"
  description = "Cloud Armor policy"

  # Whitelist traffic from certain ip address
  rule {
    action   = "allow"
    priority = "100"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = var.ip_allow_list
      }
    }

    description = "allow traffic from "
  }

  rule {
    action   = "deny(403)"
    priority = "2147483647"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }

    description = "Default deny all rule."
  }
}


resource "google_compute_url_map" "tfe" {
  name        = "${var.namespace}-urlmap"
  description = "Terraform Enterprise"

  default_service = google_compute_backend_service.application.self_link
}

resource "google_compute_ssl_policy" "ssl" {
  name            = "${var.namespace}-tfe"
  profile         = "RESTRICTED"
  min_tls_version = "TLS_1_2"
}

resource "google_compute_target_https_proxy" "tfe" {
  name             = "${var.namespace}-https"
  url_map          = google_compute_url_map.tfe.self_link
  ssl_certificates = [var.cert]
  ssl_policy       = google_compute_ssl_policy.ssl.self_link
}

resource "google_compute_global_address" "application" {
  name = "${var.namespace}-tfe"
}

resource "google_compute_global_forwarding_rule" "https-app" {
  name       = "${var.namespace}-https-app"
  ip_address = google_compute_global_address.application.address
  target     = google_compute_target_https_proxy.tfe.self_link
  port_range = "443"

  load_balancing_scheme = "EXTERNAL"
}
