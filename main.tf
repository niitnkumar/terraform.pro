provider "aws" {
  region = "us-east-1"
  
}

module "vpc" {
  source = "./modules/vpc"
  
  aws_region          = var.aws_region
  aws_vpc_cidr        = var.aws_vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs= var.private_subnet_cidrs
  db_subnet_cidr      = var.db_subnet_cidr
  azs                 = var.azs
}