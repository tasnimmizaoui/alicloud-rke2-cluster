variable "region" {
  description = "Alibaba Cloud region ID"
  type        = string
  default     = "me-central-1" # Riyadh
}

variable "zone" {
  description = "Availability zone ID"
  type        = string
  default     = "me-central-1a"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/12"
}

variable "vswitch_cidr" {
  description = "CIDR block for the VSwitch"
  type        = string
  default     = "172.16.1.0/24"
}

variable "instance_type" {
  description = "ECS instance type for both master and worker"
  type        = string
  default     = "ecs.t6-c1m2.large" # 2 vCPU / 4 GiB, burstable
}

variable "disk_size" {
  description = "System disk size in GiB"
  type        = number
  default     = 40
}

variable "key_pair_name" {
  description = "Name of an existing SSH key pair in Alibaba Cloud console"
  type        = string
}

variable "allowed_cidr" {
  description = "CIDR block allowed for SSH and Kubernetes API access"
  type        = string
  default     = "0.0.0.0/0"
}