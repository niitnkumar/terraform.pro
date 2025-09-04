terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "myterraformprobucket"      
    key            = "networking/vpc.tfstate"
    region         = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
  
}

module "vpc" {
  source = "./modules/vpc"
  
  aws_region          = "us-east-1"
  aws_vpc_cidr        = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24"]
  private_subnet_cidrs= ["10.0.2.0/24", "10.0.3.0/24"]
  db_subnet_cidr      = "10.0.4.0/26"
  azs                 = ["us-east-1a", "us-east-1b"]
}
