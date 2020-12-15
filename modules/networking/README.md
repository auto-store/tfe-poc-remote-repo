# Networking

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| firewall\_ports | Additional ports to allow through the firewall | `list(string)` | `[]` | no |
| healthcheck\_ips | List of gcp health check ips to allow through the firewall | `list(string)` | <pre>[<br>  "35.191.0.0/16",<br>  "209.85.152.0/22",<br>  "209.85.204.0/22",<br>  "130.211.0.0/22"<br>]</pre> | no |
| ip\_allow\_list | IP CIDRs to alow. Defaults to the entire world. | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| namespace | Identifier for install to apply to resources | `string` | n/a | yes |
| region | The region to install into. | `string` | `"us-central1"` | no |
| subnet\_range | CIDR range for subnet | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| config | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->