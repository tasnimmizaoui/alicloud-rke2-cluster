resource "alicloud_vpc" "this" {
  vpc_name   = "rke2-lab-vpc-tasnim"
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "this" {
  vswitch_name = "rke2-lab-vswitch-tasnim"
  vpc_id       = alicloud_vpc.this.id
  cidr_block   = var.vswitch_cidr
  zone_id      = var.zone
}