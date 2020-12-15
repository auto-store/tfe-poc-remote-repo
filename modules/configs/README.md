# Config


## RHEL

```sh
sudo journalctl -u google-startup-scripts.service -o cat -f
```

<https://www.terraform.io/docs/enterprise/before-installing/rhel-requirements.html>

```sh

# sudo yum-config-manager --enable rhel-7-server-extras-rpms
sudo yum install -y docker

sudo systemctl enable docker
sudo systemctl start docker

# missing docker0 interface
sudo firewall-cmd --zone=trusted --list-all

# add docker
sudo firewall-cmd --permanent --zone=trusted --change-interface=docker0
sudo firewall-cmd --reload

# found docker0 interface
sudo firewall-cmd --zone=trusted --list-all

# remove authorization plugin, copies are optional
cp /usr/lib/systemd/system/docker.service /tmp/docker_before.service
sudo sed -i '/--authorization-plugin=rhel-push-plugin/d' /usr/lib/systemd/system/docker.service
cp /usr/lib/systemd/system/docker.service /tmp/docker_after.service


```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| local | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| add\_bash\_debug | If set to true, write some helpful debugging Bash bits to /etc/bashrc. | `bool` | `false` | no |
| distribution | Type of linux distribution to use. (ubuntu or rhel) | `string` | `"ubuntu"` | no |
| hostname | FQDN of the tfe application (i.e. tfe.company.com) | `any` | n/a | yes |
| license\_file | Path to license file for the application | `string` | n/a | yes |
| object\_store\_config | Object storage configuration | <pre>object({<br>    bucket      = string<br>    credentials = string<br>    project     = string<br>  })</pre> | n/a | yes |
| postgres\_config | Postgres configuration | <pre>object({<br>    netloc       = string<br>    dbname       = string<br>    user         = string<br>    password     = string<br>    extra_params = string<br>  })</pre> | n/a | yes |
| release\_sequence | The sequence ID for the Terraform Enterprise version to pin the cluster to. | `string` | `"latest"` | no |
| tfe\_install\_url | TFE installer script url | `string` | `"https://install.terraform.io/ptfe/stable"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudinit | Rendered cloud-init templates to pass to primary instances. |
| console\_password | The generated password for the admin console. |
| replicated\_config | Intermediate file - /etc/tfe/replicated.conf |
| replicated\_tfe\_config | Intermediate file - /etc/tfe/replicated-tfe.conf |
| startup\_script | Rendered cloud-init LIKE file to use on RHEL. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
