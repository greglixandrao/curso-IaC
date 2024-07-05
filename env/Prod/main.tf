module "prod-environment" {
  source        = "../../infra"
  instance-type = "t2.micro"
  aws-region    = "us-west-2"
  ssh-key       = "iac-prod"
  securityGroup = "Producao"
  minimum       = 2
  maximo        = 10
  asGroup       = "Prod"
  producao = true
}
