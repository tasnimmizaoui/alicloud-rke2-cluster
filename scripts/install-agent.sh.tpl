#!/bin/bash
# RKE2 Worker Node Initialization Template
# Version: v1.35.6+rke2r1

# 1. Ensure ecs-user exists and has passwordless sudo
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

# 3. Fetch exact instance data from Alibaba Cloud Metadata Server
META_EP="http://100.100.100.200/latest/meta-data"
REGION_ID=$(curl -s $META_EP/region-id)
INSTANCE_ID=$(curl -s $META_EP/instance-id)
PROVIDER_ID="alicloud://$REGION_ID.$INSTANCE_ID"

# 4. Write the configuration file to join the cluster with Provider ID injected
mkdir -p /etc/rancher/rke2/
cat <<EOF > /etc/rancher/rke2/config.yaml
server: "https://${master_ip}:9345"
token: "${rke2_token}"
cloud-provider-name: "external"
kubelet-arg:
  - "provider-id=$PROVIDER_ID"
EOF

# 5. Install RKE2 Agent (Worker) specifying the exact version and agent type
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" INSTALL_RKE2_VERSION="v1.35.6+rke2r1" sh -

# 6. Enable and start the RKE2 Agent service
systemctl enable rke2-agent.service
systemctl start rke2-agent.service