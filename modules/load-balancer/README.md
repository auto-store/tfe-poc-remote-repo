# Load Balancer

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cert | certificate for the load balancer | `string` | n/a | yes |
| instance\_group | primary instance group | `string` | n/a | yes |
| ip\_allow\_list | IP CIDRs to alow. Defaults to the entire world. | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| namespace | Identifier for install to apply to resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| load\_balancer\_ip | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->