#!/bin/bash

set -e -u -o pipefail
# RHEL standalone install
# sudo journalctl -u google-startup-scripts.service -o cat -f

# Set intial start time - used to calculate total time
SECONDS=0

# Copy file onto instance
echo ${license_b64} | base64 -d > /etc/replicated.rli
echo ${replicated_conf_b64} | base64 -d > /etc/replicated.conf
echo ${replicated_tfe_conf_b64} | base64 -d > /etc/replicated-tfe.conf

%{ if bash_debug_b64 != "" }# Bash debugging (optional)
echo ${bash_debug_b64} | base64 -d >> /etc/profile.d/tfe.sh
%{ endif ~}

# Download install.sh
echo "Downloading install.sh from ${tfe_install_url}"
sudo mkdir -p /etc/tfe
sudo curl -o /etc/tfe/install.sh ${tfe_install_url}
sudo chmod +x /etc/tfe/install.sh

# Install and enable docker
# sudo yum-config-manager --enable rhel-7-server-extras-rpms
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker

# https://www.terraform.io/docs/enterprise/before-installing/network-requirements.html#other-configuration
# https://www.terraform.io/docs/enterprise/before-installing/rhel-requirements.html
sudo tee /etc/docker/daemon.json <<EOF
{
  "mtu": 1460
}
EOF
sudo sed -i '/authorization-plugin=rhel-push-plugin/d' /usr/lib/systemd/system/docker.service
sudo systemctl daemon-reload && systemctl restart docker
sudo docker info 2> /dev/null | grep Authorization ||  [[ $? == 1 ]]
sudo docker info 2> /dev/null | grep dev/loop      ||  [[ $? == 1 ]]
sudo docker info 2> /dev/null | grep overlay2

# add docker to firewalld
sudo firewall-cmd --permanent --zone=trusted --change-interface=docker0
sudo firewall-cmd --reload
sudo systemctl stop firewalld
sudo systemctl restart docker

if private_ip=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip); then
  echo "Using Google Metadata"
else
  private_ip=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network?api-version=2017-08-01" | jq -r .interface[0].ipv4.ipAddress[0].privateIpAddress)
fi
# network-interfaces/0/access-configs/0/external-ip
# public_ip=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/?api-version=2017-08-01" | jq -r .interface[0].ipv4.ipAddress[0].publicIpAddress)

%{ if add_gcp_logging != "" }# GCP logging to stack driver (optional)
echo ${add_gcp_logging} | base64 -d >> /tmp/gcp-logging-agent.sh
source /tmp/gcp-logging-agent.sh
%{ endif ~}

sudo /etc/tfe/install.sh \
    no-proxy \
    no-docker \
    bypass-firewalld-warning \
    ignore-preflights \
    private-address=$private_ip \
    public-address=$private_ip

# sleep at beginning of TFE install
NOW=$(date +"%FT%T")
echo "[$NOW]  Sleeping for 5 minutes while TFE installs..."
sleep 300

# poll install status against TFE health check endpoint
while ! curl -ksfS --connect-timeout 5 https://$private_ip/_health_check?full=1; do
  sleep 5
done
sudo systemctl start firewalld
sudo systemctl restart docker

# poll install status against TFE health check endpoint
while ! curl -ksfS --connect-timeout 5 https://$private_ip/_health_check?full=1; do
  sleep 5
done

# end script
NOW=$(date +"%FT%T")
duration=$SECONDS
echo "[$NOW]  Finished TFE user_data script."
echo "  $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
