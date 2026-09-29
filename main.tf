terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "tf-state-backend-mohamed-hamed-2026"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}



data "http" "workstation_ip" {
  url = "https://ipv4.icanhazip.com"
}

module "network" {
  source = "./modules/aws-network"

  environment = terraform.workspace
  my_ip       = chomp(data.http.workstation_ip.response_body)
}


module "compute" {
  source = "./modules/aws-compute"

  environment   = terraform.workspace
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.public_subnet_id
  bastion_sg_id = module.network.bastion_sg_id
}
