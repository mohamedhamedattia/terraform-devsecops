provider "aws" {
  region = var.aws_region
}

module "network" {
  source              = "./modules/network"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  environment_name    = var.environment_name
}

module "security" {
  source           = "./modules/security"
  vpc_id           = module.network.vpc_id
  environment_name = var.environment_name
}

module "compute" {
  source            = "./modules/compute"
  instance_type     = var.instance_type
  subnet_ids        = module.network.subnet_ids
  security_group_id = module.security.security_group_id
  environment_name  = var.environment_name
}