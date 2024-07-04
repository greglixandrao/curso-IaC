module "prod-environment" {
  source        = "../../infra"
  instance-type = "t3.micro"
  aws-region    = "us-west-2"
  ssh-key       = "iac-prod"
  securityGroup = "Producao"
  minimum       = 1
  maximo        = 10
  asGroup       = "Prod"
}
