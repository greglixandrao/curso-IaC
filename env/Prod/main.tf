module "prod-environment" {
  source        = "../../infra"
  instance-type = "t3.micro"
  aws-region    = "us-west-2"
  ssh-key       = "iac-prod"
}

output "dev_IP" {
  value = module.prod-environment.public_IP
}
