# TFE

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| auto\_healing\_enabled | If the autohealing should be turned on for the instance group manager. | `bool` | `true` | no |
| cloud-init | Cloud init script to run on the instance. | <pre>object({<br>    content  = string<br>    encoding = string<br>  })</pre> | <pre>{<br>  "content": "",<br>  "encoding": ""<br>}</pre> | no |
| instance\_config | n/a | <pre>object({<br>    machine_type   = string<br>    image_family   = string<br>    image_project  = string<br>    boot_disk_size = number<br>    type           = string<br>  })</pre> | <pre>{<br>  "boot_disk_size": 40,<br>  "image_family": "ubuntu-1804-lts",<br>  "image_project": "ubuntu-os-cloud",<br>  "machine_type": "n1-standard-2",<br>  "type": "pd-ssd"<br>}</pre> | no |
| labels | Labels to apply to the resources bucket | `map(string)` | `{}` | no |
| namespace | The name to prefix to resources to keep them unique. | `any` | n/a | yes |
| networking\_config | n/a | <pre>object({<br>    network    = string<br>    subnetwork = string<br>  })</pre> | n/a | yes |
| public\_access | If the instance should have a public IP. | `bool` | `true` | no |
| region | The region to install into. | `string` | n/a | yes |
| startup\_script | Fully baked startup script for RHEL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_group | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->