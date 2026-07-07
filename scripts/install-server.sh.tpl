#!/bin/bash
# ==========================================
# Unified RKE2 Master Node Initialization Template
# Version: v1.36.2+rke2r1 (Fresh Install)
# ==========================================

# 1. Create the ecs-user and grant passwordless sudo permissions
id -u ecs-user &>/dev/null || useradd -m -s /bin/bash ecs-user
echo "ecs-user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ecs-user
chmod 0440 /etc/sudoers.d/ecs-user

# 2. Sync the Alibaba Cloud injected SSH keys from root to ecs-user
mkdir -p /home/ecs-user/.ssh
if [ -f /root/.ssh/authorized_keys ]; then
    cp /root/.ssh/authorized_keys /home/ecs-user/.ssh/
    chown -R ecs-user:ecs-user /home/ecs-user/.ssh
    chmod 700 /home/ecs-user/.ssh
    chmod 600 /home/ecs-user/.ssh/authorized_keys
fi

# 3. Write minimal configuration file (just the token needed for fresh v1.36)
mkdir -p /etc/rancher/rke2/
cat <<EOF > /etc/rancher/rke2/config.yaml
token: "${rke2_token}"
cni: calico
disable:
  - rke2-traefik
EOF

# 4. Install and start RKE2 Server 
curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION="v1.36.2+rke2r1" sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service

# 5. Configure cluster admin access for ecs-user
mkdir -p /home/ecs-user/.kube
while [ ! -f /etc/rancher/rke2/rke2.yaml ]; do sleep 5; done
cp /etc/rancher/rke2/rke2.yaml /home/ecs-user/.kube/config
chown -R ecs-user:ecs-user /home/ecs-user/.kube
chmod 600 /home/ecs-user/.kube/config

# 6. Add RKE2 binaries to ecs-user path
echo 'export PATH=$PATH:/var/lib/rancher/rke2/bin' >> /home/ecs-user/.bashrc