terraform {
  required_providers {
	aws = {
		source = "hashicorp"
		version = "~> 3.27"
	}
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region = "us-west-2"
}

resource "aws_instance" "app-server" {
  ami = "ami-03f65b8614a860c29"
  instance_type = "t2.micro"
}

tags = {
	Name = "EstudoAluraIaC"
}
