module "dev-environment" {
  source        = "../../infra"
  instance-type = "t2.micro"
  aws-region    = "us-west-2"
  ssh-key       = "iac-dev"
  securityGroup = "Dev"
  minimum       = 0
  maximo        = 1
  asGroup       = "Dev"
  producao      = false
}
