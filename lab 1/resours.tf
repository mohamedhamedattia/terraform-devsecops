locals {
  name_prefix = "app-${var.environment_name}"
  common_tags = {
    Environment = var.environment_name
    ManagedBy   = "Terraform"
  }
}

# جلب أحدث صورة Ubuntu في منطقة ستوكهولم
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

# جلب الـ Default VPC تلقائياً (وهي مضمونة الوجود ومتاحة دائماً)
data "aws_vpc" "default" {
  default = true
}

# جلب أول Subnet داخل الـ Default VPC تلقائياً
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# إنشاء Security Group وربطها بالـ Default VPC
resource "aws_security_group" "web_sg" {
  name        = "${local.name_prefix}-sg"
  description = "Allow inbound SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sg"
  })
}

# إنشاء مثيل الـ EC2 في أول Subnet متاح داخل الـ Default VPC
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-server"
  })
}