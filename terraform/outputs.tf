output "master_public_ip" {
  description = "Public IP of the master node - use for SSH and kubectl"
  value       = alicloud_instance.master.public_ip
}

output "worker_public_ip" {
  description = "Public IPs of the worker nodes"
  value       = alicloud_instance.worker[*].public_ip
}

output "master_private_ip" {
  description = "Private IP of the master node - used internally by the worker to join"
  value       = alicloud_instance.master.private_ip
}
