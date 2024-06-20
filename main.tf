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
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami                  = "ami-03c983f9003cb9cd1"
  instance_type        = "t3.micro"
  key_name             = "aws-alura-api-go-dev"
  iam_instance_profile = "EC2InstanceRole"
#   user_data            = <<-EOF
#                  #!/bin/bash
#                  cd /home/ubuntu
#                  echo "<h1>Hello World done with Terraform and AWS</h1>" > index.html
#                  nohup busybox httpd -f -p 8080 &
#                  EOF
  tags = {
    Name  = "EstudoAluraIaC com webserver"
    curso = "AluraIaC"
  }
}
