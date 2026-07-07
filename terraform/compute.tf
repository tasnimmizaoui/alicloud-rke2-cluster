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

  user_data = base64encode(templatefile("${path.module}/../scripts/install-server.sh.tpl", {
    rke2_token = var.rke2_token
  }))
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

 user_data = base64encode(templatefile("${path.module}/../scripts/install-agent.sh.tpl", {
    rke2_token = var.rke2_token
  }))
}
