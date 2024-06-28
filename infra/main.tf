terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "default"
  region  = var.aws-region
}

resource "aws_launch_template" "server" {
  image_id      = "ami-03c983f9003cb9cd1"
  instance_type = var.instance-type
  key_name      = var.ssh-key
  iam_instance_profile {
    name = "EC2InstanceRole"
  }
  tags = {
    Name  = "Formacao IaC with Terraform and Ansible"
    curso = "Formacao IAC"
  }
}

# Using auto generated key-pair
resource "aws_key_pair" "ssh-key" {
  key_name   = var.ssh-key
  public_key = file("${var.ssh-key}.pub")
}

output "public_IP" {
  value = aws_instance.app_server.public_ip
}
