variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "Public Subnet ID for the Bastion host"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security Group ID for the Bastion host"
  type        = string
}
