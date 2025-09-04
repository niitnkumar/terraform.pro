variable "aws_region" {
  description = "The AWS region to deploy resources in"
  
}


variable "aws_vpc_cidr" {
  description = "The CIDR block for the VPC"
  
}


variable "public_subnet_cidrs" {
  description = "The CIDR block for the public subnet"
  
}


variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  
}


variable "db_subnet_cidr" {
  description = "The CIDR block for the database subnet"  
  
}



variable "azs" {
  description = "The availability zones to use for the subnets"
  
}


