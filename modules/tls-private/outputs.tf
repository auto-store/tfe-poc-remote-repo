locals {
  full_cert = "${tls_locally_signed_cert.cert.cert_pem}\n${tls_self_signed_cert.ca.cert_pem}"
}

output "cert" {
  description = "Full chain certificate in PEM format."
  value       = local.full_cert
}

output "key" {
  description = "Certification key in PEM format."
  value       = tls_private_key.cert.private_key_pem
}

output "name" {
  description = "Readable name of the certificate."
  value       = "tfe-tls-pfx"
}
