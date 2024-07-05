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
  security_group_names = [var.securityGroup]
  user_data            = var.producao ? filebase64("ansible.sh") : ""
}

# Using auto generated key-pair
resource "aws_key_pair" "ssh-key" {
  key_name   = var.ssh-key
  public_key = file("${var.ssh-key}.pub")
}

resource "aws_autoscaling_group" "autoscalingGroup" {
  availability_zones = ["${var.aws-region}a", "${var.aws-region}b"]
  name               = var.asGroup
  max_size           = var.maximo
  min_size           = var.minimum
  target_group_arns  = var.producao ? [aws_lb_target_group.targetServers[0].arn] : []
  launch_template {
    id      = aws_launch_template.server.id
    version = "$Latest"
  }
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.aws-region}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.aws-region}b"
}

resource "aws_lb" "loadBalancer" {
  internal = false
  subnets  = [aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id]
  count    = var.producao ? 1 : 0
}

resource "aws_default_vpc" "default" {
}
resource "aws_lb_target_group" "targetServers" {
  name     = "targetServers"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
  count    = var.producao ? 1 : 0
}



resource "aws_lb_listener" "LB_input" {
  load_balancer_arn = aws_lb.loadBalancer[0].arn
  port              = "8000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetServers[0].arn
  }
  count = var.producao ? 1 : 0
}

resource "aws_autoscaling_policy" "autoscaling-policy-prod" {
  name                   = "autoscaling-terraform"
  autoscaling_group_name = var.asGroup
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
  count = var.producao ? 1 : 0
}
