terraform {
  required_providers {
	aws = {
		source = "hashicorp/aws"
		version = "~> 3.27"
	}
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "aws-estudos"
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami = "ami-03f65b8614a860c29"
  instance_type = "t2.micro"
  key_name = "aws-estudos-user-greglixandrao"
#   user_data = <<-EOF
# 				#!/bin/bash
# 				cd /home/ubuntu
# 				echo "<h1>Hello World done with Terraform and AWS</h1>" > index.html
# 				nohup busybox httpd -f -p 8080 &
# 				EOF
  tags = {
		Name = "EstudoAluraIaC com webserver"
		curso = "AluraIaC"
	}
}
