resource "alicloud_security_group" "this" {
  security_group_name   = "rke2-lab-sg-tasnim"
  vpc_id = alicloud_vpc.this.id
}

resource "alicloud_security_group_rule" "ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.this.id
  cidr_ip           = var.allowed_cidr
}

resource "alicloud_security_group_rule" "k8s_api" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "6443/6443"
  priority          = 1
  security_group_id = alicloud_security_group.this.id
  cidr_ip           = var.allowed_cidr
}

resource "alicloud_security_group_rule" "icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.this.id
  cidr_ip           = "0.0.0.0/0"
}

# NOTE: No explicit rule for master<->worker traffic (6443, 9345, 10250, 8472/UDP).
# Basic Security Groups default to an "Internal Interconnectivity" policy that already
# allows full traffic between members of the same group - confirmed during manual setup.
# Do not add a self-referencing rule here; the console rejects it for the same reason.

# Required for Let's Encrypt to validate our domain
resource "alicloud_security_group_rule" "http_public" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.this.id
  cidr_ip           = "0.0.0.0/0" 
}

# Required  to actually view the Rancher UI securely later
resource "alicloud_security_group_rule" "https_public" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = alicloud_security_group.this.id
  cidr_ip           = "0.0.0.0/0" 
}