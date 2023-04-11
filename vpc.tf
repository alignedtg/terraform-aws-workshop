data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = ">= 4.0.0"
  name                 = "devopsdays-workshop-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = local.azs
  public_subnets       = var.public_subnets
  enable_nat_gateway   = false
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}
