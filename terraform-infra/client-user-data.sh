#!/bin/bash
set -euo pipefail

USERNAME=devops # Customize the sudo non-root username here

# Create user and immediately expire password to force a change on login
useradd --create-home --shell "/bin/bash" --groups sudo "${USERNAME}"
passwd --delete "${USERNAME}"
chage --lastday 0 "${USERNAME}"

# Move ssh keys from root to user's homedir with all necessary permissions
rsync --archive --chown="${USERNAME}:${USERNAME}" ~/.ssh "/home/${USERNAME}"

# Disable root SSH at all
sed --in-place 's/^PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
if sshd -t -q; then systemctl restart sshd; fi

# Install Docker (Docker docs)
NEEDRESTART_MODE=a
apt-get update
apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Allow current user to use docker without sudo
usermod -aG docker ${USERNAME} 

# Install Graylog-sidecar. Edit /etc/graylog/sidecar/sidecar.yml manually,  install and start service!!!
wget https://packages.graylog2.org/repo/packages/graylog-sidecar-repository_1-5_all.deb
dpkg -i graylog-sidecar-repository_1-5_all.deb
apt update && sudo apt install graylog-sidecar  
# graylog-sidecar -service install
# systemctl enable graylog-sidecar
# systemctl start graylog-sidecar

# Install Filebeats
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
apt-get update && sudo apt-get install -y filebeat
systemctl enable filebeat
systemctl start filebeat



