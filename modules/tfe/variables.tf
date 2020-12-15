variable "namespace" {
  description = "The name to prefix to resources to keep them unique."
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the resources bucket"
  default     = {}
}

variable "region" {
  type        = string
  description = "The region to install into."
}

variable "networking_config" {
  type = object({
    network    = string
    subnetwork = string
  })
}

variable "instance_config" {
  type = object({
    machine_type   = string
    image_family   = string
    image_project  = string
    boot_disk_size = number
    type           = string
  })
  default = {
    machine_type   = "n1-standard-2"
    image_family   = "ubuntu-1804-lts"
    image_project  = "ubuntu-os-cloud"
    boot_disk_size = 40
    type           = "pd-ssd"
  }
}

variable "startup_script" {
  description = "Fully baked startup script for RHEL"
  default     = ""
}

variable "cloud-init" {
  type = object({
    content  = string
    encoding = string
  })
  description = "Cloud init script to run on the instance."
  default = {
    content  = ""
    encoding = ""
  }
}

# If debugging, this should be set to false to avoid rebuilding of the instance.
variable "auto_healing_enabled" {
  type        = bool
  description = "If the autohealing should be turned on for the instance group manager."
  default     = true
}

# If debugging, this should be set to true
variable "public_access" {
  type        = bool
  description = "If the instance should have a public IP."
  default     = true
}
