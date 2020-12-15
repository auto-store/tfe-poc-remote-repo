domain    = "demo.com"
subdomain = "tfe"

region           = "europe-west2"
project          = "tharris-demo-env"
credentials      = "/Users/tomh/Desktop/tharris-demo-env-558a459a0f21.json"
tfe_license_file = "/Users/tomh/Desktop/tharris-internal-se-demo.rli"

namespace = "tharris-poc"
labels = {
  owner = "tfe"
  iac   = "tfe"
}

public_ip_allowlist = [
  "0.0.0.0"
]