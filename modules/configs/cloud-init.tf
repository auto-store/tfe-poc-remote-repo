data "template_file" "cloud_init_config" {
  template = file("${path.module}/templates/cloud-init/cloud-config.yaml")

  vars = {
    tfe_install_url = var.tfe_install_url
    distribution    = var.distribution
    license_b64     = filebase64(var.license_file)
    install_tfe_sh  = base64encode(file("${path.module}/files/install-tfe.sh"))

    replicated-conf     = base64encode(data.template_file.replicated_config.rendered)
    replicated-tfe-conf = base64encode(data.template_file.replicated_tfe_config.rendered)
  }
}

data "template_cloudinit_config" "cloud_init_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_init_config.rendered
  }
}

resource "local_file" "user-data" {
  filename = "./.terraform/tfe-user-data.sh"
  content  = data.template_cloudinit_config.cloud_init_config.part[0].content
}

resource "local_file" "replicated-conf" {
  filename = "./.terraform/replicated-conf.json"
  content  = data.template_file.replicated_config.rendered
}

resource "local_file" "replicated-tfe-conf" {
  filename = "./.terraform/replicated-tfe-conf.json"
  content  = data.template_file.replicated_tfe_config.rendered
}

# RHEL
data "template_file" "startup_script" {
  template = file("${path.module}/templates/rhel/install-tfe.sh")

  vars = {
    tfe_install_url         = var.tfe_install_url
    license_b64             = filebase64(var.license_file)
    replicated_conf_b64     = base64encode(data.template_file.replicated_config.rendered)
    replicated_tfe_conf_b64 = base64encode(data.template_file.replicated_tfe_config.rendered)
    bash_debug_b64          = var.add_bash_debug ? base64encode(file("${path.module}/files/bash-debug.sh")) : ""
    add_gcp_logging         = var.add_gcp_logging ? base64encode(file("${path.module}/files/gcp-logging-agent.sh")) : ""
  }
}

resource "local_file" "startup_script" {
  filename = "./.terraform/install-tfe-rhel.sh"
  content  = data.template_file.startup_script.rendered
}
