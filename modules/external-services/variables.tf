variable "namespace" {
  description = "The name to prefix to resources to keep them unique."
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the resources bucket"
  default     = {}
}

variable "network" {
  type        = string
  description = "google_compute_network.tfe_vpc.self_link"
}

variable "credentials" {
  type        = string
  description = "Path to GCP credentials .json file"
}


variable "postgres_instance_config" {
  description = "GCP specific settings for postgres."
  type = object({
    machinetype       = string
    dbname            = string
    availability_type = string
    backup_start_time = string
    username          = string
  })
  default = {
    machinetype       = "db-custom-2-13312"
    dbname            = "tfe"
    availability_type = "ZONAL"
    username          = "tfe"
    backup_start_time = ""
  }
}
