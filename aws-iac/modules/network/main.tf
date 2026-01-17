
terraform {
	required_version = ">= 1.0.0"
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = ">= 4.0"
		}
	}
}

provider "aws" {
	region = var.region
}



data "aws_availability_zones" "available" {
	state = "available"
}


#Create VPC
resource "aws_vpc" "vpc" {
		cidr_block           = var.vpc_cidr
		enable_dns_hostnames = var.enable_dns_hostnames
		enable_dns_support   = var.enable_dns_support

		tags = merge(
    {
      Name = "${var.name}-vpc"
    },
    var.common_tags
  )
}

# Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
		vpc_id = aws_vpc.vpc.id

		tags = merge(
    {
      Name = "${var.name}-igw"
    },
    var.common_tags
  )
}

# Public subnets
resource "aws_subnet" "public" {
	count                   = var.public_count
	vpc_id                  = aws_vpc.vpc.id
	cidr_block              = var.public_subnet_cidrs[count.index]
	availability_zone       = data.aws_availability_zones.available.names[count.index % var.az_count]
	map_public_ip_on_launch = var.map_public_ip_on_launch


	tags = merge(
    {
      Name = "${var.name}-public-${count.index + 1}"
    },
    var.common_tags
  )

}

# Private subnets
resource "aws_subnet" "private" {
	count             = var.private_count
	vpc_id            = aws_vpc.vpc.id
	cidr_block        = var.private_subnet_cidrs[count.index]
	availability_zone = data.aws_availability_zones.available.names[count.index % var.az_count]
	tags = merge(
    {
      Name = "${var.name}-private-${count.index + 1}"
    },
    var.common_tags
  )

}

# Single Elastic IP for NAT Gateway (shared by private subnets)
resource "aws_eip" "nat" {
	domain = var.domain

	tags = merge(
    {
      Name = "${var.name}-nat"
    },
    var.common_tags
  )

}

# Single NAT Gateway placed in the first public subnet
resource "aws_nat_gateway" "nat" {
	allocation_id = aws_eip.nat.id
	subnet_id     = aws_subnet.public[0].id

	tags = merge(
    {
      Name = "${var.name}-nat"
    },
    var.common_tags
  )
}


# Public route table and route to IGW
resource "aws_route_table" "public" {
	vpc_id = aws_vpc.vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}


	tags = merge(
    {
      Name = "${var.name}-Public-rt"
    },
    var.common_tags
  )
}

# Public route table assiciation with public subnet
resource "aws_route_table_association" "public" {
	count          = var.public_count
	subnet_id      = aws_subnet.public[count.index].id
	route_table_id = aws_route_table.public.id
}

# Private route table(s) - create one per private subnet and route via corresponding NAT
resource "aws_route_table" "private" {
	count  = var.private_count
	vpc_id = aws_vpc.vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.nat.id
	}


	tags = merge(
    {
      Name = "${var.name}-private-rt-${count.index + 1}"
    },
    var.common_tags
  )
}

# Private route table assiciation with private subnet
resource "aws_route_table_association" "private" {
	count          = var.private_count
	subnet_id      = aws_subnet.private[count.index].id
	route_table_id = aws_route_table.private[count.index].id
}

# S3 VPC Endpoint for private connectivity to S3
resource "aws_vpc_endpoint" "s3" {
	count             = var.enable_s3_endpoint ? 1 : 0
	vpc_id            = aws_vpc.vpc.id
	service_name      = "com.amazonaws.${var.region}.s3"
	vpc_endpoint_type = "Gateway"
	route_table_ids   = concat([aws_route_table.public.id], aws_route_table.private[*].id)

	tags = merge(
		{
			Name = "${var.name}-s3-endpoint"
		},
		var.common_tags
	)
}

# Default Network ACL for public subnets (allow all)
resource "aws_network_acl" "public" {
	vpc_id = aws_vpc.vpc.id

	   egress {
		   protocol   = var.public_nacl_protocol
		   rule_no    = var.nacl_rule_no
		   action     = var.nacl_action
		   cidr_block = var.public_nacl_egress_cidr
		   from_port  = var.public_nacl_from_port
		   to_port    = var.public_nacl_to_port
	   }

	   ingress {
		   protocol   = var.public_nacl_protocol
		   rule_no    = var.nacl_rule_no
		   action     = var.nacl_action
		   cidr_block = var.public_nacl_ingress_cidr
		   from_port  = var.public_nacl_from_port
		   to_port    = var.public_nacl_to_port
	   }

	tags = merge({
		Name = "${var.name}-public-nacl"
	}, var.common_tags)
}

# nacl association with public subnets
resource "aws_network_acl_association" "public" {
	count      = var.public_count
	network_acl_id = aws_network_acl.public.id
	subnet_id      = aws_subnet.public[count.index].id
}

# Default Network ACL for private subnets (allow all)
resource "aws_network_acl" "private" {
	vpc_id = aws_vpc.vpc.id

	   egress {
		   protocol   = var.private_nacl_protocol
		   rule_no    = var.nacl_rule_no
		   action     = var.nacl_action
		   cidr_block = var.private_nacl_egress_cidr
		   from_port  = var.private_nacl_from_port
		   to_port    = var.private_nacl_to_port
	   }

	   ingress {
		   protocol   = var.private_nacl_protocol
		   rule_no    = var.nacl_rule_no
		   action     = var.nacl_action
		   cidr_block = var.private_nacl_ingress_cidr
		   from_port  = var.private_nacl_from_port
		   to_port    = var.private_nacl_to_port
	   }

	tags = merge({
		Name = "${var.name}-private-nacl"
	}, var.common_tags)
}

# nacl association with private subnets
resource "aws_network_acl_association" "private" {
	count      = var.private_count
	network_acl_id = aws_network_acl.private.id
	subnet_id      = aws_subnet.private[count.index].id
}