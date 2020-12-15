variable "namespace" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "region" {
  type        = string
  description = "The region to install into."
  default     = "us-central1"
}

variable "subnet_range" {
  type        = string
  description = "CIDR range for subnet"
  default     = "10.0.0.0/16"
}

variable "healthcheck_ips" {
  type        = list(string)
  description = "List of gcp health check ips to allow through the firewall"
  default     = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
}

variable "firewall_ports" {
  type        = list(string)
  description = "Additional ports to allow through the firewall"
  default     = []
}

variable "ip_allow_list" {
  type        = list
  description = "IP CIDRs to alow. Defaults to the entire world."
  default     = ["0.0.0.0/0"]
}
