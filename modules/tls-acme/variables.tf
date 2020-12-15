variable "domain" {
  description = "The domain you wish to use, this will be subdomained. `example.com`"
}

variable "hostname" {
  description = "The full hostname that will be used. `tfe.example.com`"
}

variable "certificate_duration" {
  description = "Length in hours for the certificate and authority to be valid. Defaults to 6 months."
  default     = 24 * 30 * 6
}

variable "dns_challenge_type" {
  description = "The DNS challenge type, full list here: https://www.terraform.io/docs/providers/acme/dns_providers/index.html. Be sure to also set the required ENV variables."
}

variable "region" {
  default = "europe-west2"
}

variable "project" {
   default = "tharris-demo-env"
}

variable "credentials" {
    default  = "/Users/tomh/Desktop/tharris-demo-env-558a459a0f21.json"
}