module "dev-environment" {
  source        = "../../infra"
  instance-type = "t3.micro"
  aws-region    = "us-west-2"
  ssh-key       = "iac-dev"
  securityGroup = "Dev"
  minimum       = 0
  maximo        = 2
  asGroup       = "Dev"
}

output "dev_IP" {
  value = module.dev-environment.public_IP
}
