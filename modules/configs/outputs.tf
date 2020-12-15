output "cloudinit" {
  value       = data.template_cloudinit_config.cloud_init_config.rendered
  description = "Rendered cloud-init templates to pass to primary instances."
}

output "console_password" {
  value       = random_string.console_password.result
  description = "The generated password for the admin console."
}

output "startup_script" {
  value       = data.template_file.startup_script.rendered
  description = "Rendered cloud-init LIKE file to use on RHEL."
}

output "replicated_config" {
  description = "Intermediate file - /etc/tfe/replicated.conf"
  value       = data.template_file.replicated_config.rendered
}

output "replicated_tfe_config" {
  description = "Intermediate file - /etc/tfe/replicated-tfe.conf"
  value       = data.template_file.replicated_tfe_config.rendered
}

