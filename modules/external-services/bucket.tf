resource "random_pet" "gcs" {
  length = 2
}

resource "google_storage_bucket" "tfe-bucket" {
  name     = "${var.namespace}-storage-${random_pet.gcs.id}"
  location = "us"
  # TODO: update to regional bucket
  # storage_class = "REGIONAL"
  # - (Optional, Default: 'STANDARD') The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE.

  # Remove this for production builds
  force_destroy = true
  labels        = var.labels
}
