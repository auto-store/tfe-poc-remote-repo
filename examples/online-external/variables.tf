variable "namespace" {
  description = "The name to prefix to resources to keep them unique."
}

variable "domain" {
  description = "The domain you wish to use, this will be subdomained. `example.com`."
}

variable "subdomain" {
  description = "The subdomain you wish to use `mycompany-tfe`"
}

variable "tfe_license_file" {}

variable "credentials" {
  type        = string
  description = "Path to GCP credentials .json file"
}

variable "project" {
  type        = string
  description = "Name of the project to deploy into"
}

variable "region" {
  type        = string
  description = "The region to install into."
  default     = "us-central1"
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the resources bucket"
  default     = {}
}

variable "public_ip_allowlist" {
  description = "List of public IP addresses to allow into the network."
  type        = list
  default     = []
}
