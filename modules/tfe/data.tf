data "google_compute_zones" "available" {
  region = var.region
}

data "google_compute_image" "image" {
    name   = "rhel-7-v20200910"
    project  = "rhel-cloud"
}

locals {
  zone = data.google_compute_zones.available.names[0]
}
