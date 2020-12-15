variable "namespace" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "cert" {
  type        = string
  description = "certificate for the load balancer"
}

variable "instance_group" {
  type        = string
  description = "primary instance group"
}

variable "ip_allow_list" {
  type        = list
  description = "IP CIDRs to alow. Defaults to the entire world."
  default     = ["0.0.0.0/0"]
}
