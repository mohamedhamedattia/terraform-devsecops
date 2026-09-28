output "vpc_id" {
  value = module.network.vpc_id
}

output "instance_public_ips" {
  value = module.compute.public_ips
}