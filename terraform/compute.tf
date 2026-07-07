data "alicloud_images" "ubuntu" {
  name_regex  = "^ubuntu_22_04_x64"
  most_recent = true
  owners      = "system"
}

resource "alicloud_instance" "master" {
  instance_name              = "rke2-master-tasnim"
  instance_type              = var.instance_type
  image_id                   = data.alicloud_images.ubuntu.images[0].id
  security_groups            = [alicloud_security_group.this.id]
  vswitch_id                 = alicloud_vswitch.this.id
  system_disk_category       = "cloud_essd"
  system_disk_size           = var.disk_size
  key_name                   = var.key_pair_name
  internet_max_bandwidth_out = 5 
  
  # To provision a non-root user
  user_data = base64encode(<<-EOF
              #!/bin/bash
              # Create the user
              useradd -m -s /bin/bash ecs-user
              usermod -aG sudo ecs-user
              echo "ecs-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ecs-user

              # Copy the Alibaba Cloud injected SSH key from root to the new user
              mkdir -p /home/ecs-user/.ssh
              cp /root/.ssh/authorized_keys /home/ecs-user/.ssh/
              chown -R ecs-user:ecs-user /home/ecs-user/.ssh
              chmod 700 /home/ecs-user/.ssh
              chmod 600 /home/ecs-user/.ssh/authorized_keys
              EOF
  )

  
}

resource "alicloud_instance" "worker" {
  instance_name              = "rke2-worker-tasnim"
  instance_type              = var.instance_type
  image_id                   = data.alicloud_images.ubuntu.images[0].id
  security_groups            = [alicloud_security_group.this.id]
  vswitch_id                 = alicloud_vswitch.this.id
  system_disk_category       = "cloud_essd"
  system_disk_size           = var.disk_size
  key_name                   = var.key_pair_name
  internet_max_bandwidth_out = 5

  user_data = base64encode(<<-EOF
              #!/bin/bash
              # Create the user
              useradd -m -s /bin/bash ecs-user
              usermod -aG sudo ecs-user
              echo "ecs-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ecs-user

              # Copy the Alibaba Cloud injected SSH key from root to the new user
              mkdir -p /home/ecs-user/.ssh
              cp /root/.ssh/authorized_keys /home/ecs-user/.ssh/
              chown -R ecs-user:ecs-user /home/ecs-user/.ssh
              chmod 700 /home/ecs-user/.ssh
              chmod 600 /home/ecs-user/.ssh/authorized_keys
              EOF
  )
}
