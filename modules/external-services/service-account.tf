resource "google_service_account" "bucket" {
  account_id   = "${var.namespace}-tfe-bucket"
  display_name = "Used by Terraform Enterprise to authenticate with GCS Bucket."
  description  = "TFE to GCS Bucket auth."
}

resource "google_service_account_key" "bucket" {
  service_account_id = google_service_account.bucket.name
}

resource "google_storage_bucket_iam_member" "member-object" {
  bucket = google_storage_bucket.tfe-bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.bucket.email}"
}

resource "google_storage_bucket_iam_member" "member-bucket" {
  bucket = google_storage_bucket.tfe-bucket.name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${google_service_account.bucket.email}"
}
