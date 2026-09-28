variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-north-1" # <--- تم التحديث لمنطقة ستوكهولم
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
  default     = "t3.micro"
}

variable "environment_name" {
  type        = string
  description = "Environment name tag"
  default     = "dev"
}