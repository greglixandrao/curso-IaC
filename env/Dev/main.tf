module "dev-environment" {
  source        = "../../infra"
  instance-type = "t3.micro"
  aws-region    = "us-west-2"
  ssh-key       = "iac-dev"
}

output "dev_IP" {
  value = module.dev-environment.public_IP
}
