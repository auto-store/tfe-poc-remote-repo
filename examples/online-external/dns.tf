# Update your own DNS
# provider "azurerm" {
#   features {}
# }

# resource "azurerm_dns_a_record" "public" {
#   resource_group_name = "tstraub-ptfe-binaries-rg"
#   zone_name           = var.domain
#   name                = var.subdomain
#   records             = [module.load-balancer.load_balancer_ip]
#   ttl                 = 300
# }

