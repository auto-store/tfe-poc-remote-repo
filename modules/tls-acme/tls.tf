resource "tls_private_key" "acme" {
  algorithm = "RSA"
}

resource "acme_registration" "tls" {
  account_key_pem = tls_private_key.acme.private_key_pem
  email_address   = format("%s@domainsbyproxy.com", var.domain)
}

resource "acme_certificate" "tls" {
  account_key_pem = acme_registration.tls.account_key_pem
  common_name     = var.hostname

  dns_challenge {
    provider = var.dns_challenge_type

    config = {
       GCE_SERVICE_ACCOUNT_FILE = var.credentials
       GCE_PROJECT     = var.project
     }
  }
}
