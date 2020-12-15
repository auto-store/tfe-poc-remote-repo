locals {
  full_cert = "${acme_certificate.tls.certificate_pem}\n${acme_certificate.tls.issuer_pem}"
}

output "cert" {
  description = "Full chain certificate in PEM format."
  value       = local.full_cert
}

output "key" {
  description = "Certification key in PEM format."
  value       = acme_certificate.tls.private_key_pem
}

output "name" {
  description = "Readable name of the certificate."
  value       = "tfe-tls-pfx"
}
