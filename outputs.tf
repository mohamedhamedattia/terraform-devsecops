output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = module.compute.bastion_public_ip
}

output "bastion_private_key" {
  description = "Private SSH key for the Bastion Host"
  value       = module.compute.private_key_pem
  sensitive   = true
}
