variable "aws_vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}


variable "azs" {
  type = list(string)
}

variable "aws_region" {
  type = string
  
}

variable "db_subnet_cidr" {
  description = "CIDR block for the DB subnet"
  type        = string
}