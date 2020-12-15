# Let's Encrypt TLS Certificates

Creates publicly trusted TLS Certificates.

Requires access to a domain you own and the ability to provide a DNS challenge request.

This example uses Azure DNS as the challenge, but [many others](https://www.terraform.io/docs/providers/acme/dns_providers/index.html) are supported.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| acme | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| certificate\_duration | Length in hours for the certificate and authority to be valid. Defaults to 6 months. | `number` | `4320` | no |
| dns\_challenge\_type | The DNS challenge type, full list here: https://www.terraform.io/docs/providers/acme/dns_providers/index.html. Be sure to also set the required ENV variables. | `any` | n/a | yes |
| domain | The domain you wish to use, this will be subdomained. `example.com` | `any` | n/a | yes |
| hostname | The full hostname that will be used. `tfe.example.com` | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cert | Full chain certificate in PEM format. |
| key | Certification key in PEM format. |
| name | Readable name of the certificate. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->