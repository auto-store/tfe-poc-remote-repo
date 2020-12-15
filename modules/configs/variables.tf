variable "distribution" {
  type        = string
  description = "Type of linux distribution to use. (ubuntu or rhel)"
  default     = "ubuntu"
}

variable "tfe_install_url" {
  type        = string
  description = "TFE installer script url"
  default     = "https://install.terraform.io/ptfe/stable"
}

variable "release_sequence" {
  type        = string
  description = "The sequence ID for the Terraform Enterprise version to pin the cluster to."
  default     = "latest"
}

variable "hostname" {
  description = "FQDN of the tfe application (i.e. tfe.company.com)"
}

variable "license_file" {
  type        = string
  description = "Path to license file for the application"
}

variable "postgres_config" {
  description = "Postgres configuration"
  type = object({
    netloc       = string
    dbname       = string
    user         = string
    password     = string
    extra_params = string
  })
}

variable "object_store_config" {
  description = "Object storage configuration"
  type = object({
    bucket      = string
    credentials = string
    project     = string
  })
}

variable "add_bash_debug" {
  description = "If set to true, write some helpful debugging Bash bits to /etc/bashrc."
  type        = bool
  default     = false
}

variable "add_gcp_logging" {
  description = "If set to true, write some helpful debugging Bash bits to /etc/bashrc."
  type        = bool
  default     = false
}
