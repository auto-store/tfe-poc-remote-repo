output "object_storage_config" {
  value = {
    bucket      = google_storage_bucket.tfe-bucket.name
    project     = google_storage_bucket.tfe-bucket.project
    credentials = base64decode(google_service_account_key.bucket.private_key)
  }
}

output "postgres_config" {
  value = {
    netloc       = google_sql_database_instance.tfe.private_ip_address
    dbname       = google_sql_database.tfe.name
    user         = google_sql_user.tfe.name
    password     = google_sql_user.tfe.password
    extra_params = "sslmode=require"
  }
}

