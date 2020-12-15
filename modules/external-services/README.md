# External Services

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| google | n/a |
| google-beta | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| credentials | Path to GCP credentials .json file | `string` | n/a | yes |
| labels | Labels to apply to the resources bucket | `map(string)` | `{}` | no |
| namespace | The name to prefix to resources to keep them unique. | `any` | n/a | yes |
| network | google\_compute\_network.tfe\_vpc.self\_link | `string` | n/a | yes |
| postgres\_instance\_config | GCP specific settings for postgres. | <pre>object({<br>    machinetype       = string<br>    dbname            = string<br>    availability_type = string<br>    backup_start_time = string<br>    username          = string<br>  })</pre> | <pre>{<br>  "availability_type": "ZONAL",<br>  "backup_start_time": "",<br>  "dbname": "tfe",<br>  "machinetype": "db-custom-2-13312",<br>  "username": "tfe"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| object\_storage\_config | n/a |
| postgres\_config | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->