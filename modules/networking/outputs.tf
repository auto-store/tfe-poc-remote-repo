output "config" {
  value = {
    subnetwork = google_compute_subnetwork.tfe_subnet.self_link
    network    = google_compute_subnetwork.tfe_subnet.network
  }
}
