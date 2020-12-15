# Private TLS Certificates

Creates private CA, then creates a private TLS cert from that CA.

Not recommended for production, but provides a good base for testing common scenarios with private certificate authorities.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| certificate\_duration | Length in hours for the certificate and authority to be valid. Defaults to 6 months. | `number` | `4320` | no |
| domain | The domain you wish to use, this will be subdomained. `example.com` | `any` | n/a | yes |
| hostname | The full hostname that will be used. `tfe.example.com` | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cert | Full chain certificate in PEM format. |
| key | Certification key in PEM format. |
| name | Readable name of the certificate. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->