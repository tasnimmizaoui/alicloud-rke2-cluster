terraform {
  required_version = ">= 1.5"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.226"
    }
  }
}

provider "alicloud" {
  region = var.region
  # Credentials read from ALICLOUD_ACCESS_KEY / ALICLOUD_SECRET_KEY
}