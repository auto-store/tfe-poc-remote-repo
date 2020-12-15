output "tfe" {
  description = "TFE access values."
  value = {
    app_url          = "https://${local.hostname}"
    console_url      = "https://${local.hostname}:8800"
    lb_public_ip     = module.load-balancer.load_balancer_ip
    console_password = module.configs.console_password
  }
}
