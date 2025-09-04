provider "aws" {
  region = var.aws_region
}


resource "aws_vpc" "demo_vpc" {
  cidr_block = var.aws_vpc_cidr

  tags = {
    Name = "demo-vpc"
  }
}



# Public subnet 
resource "aws_subnet" "demo_public_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "demo-public-subnet"
  }
}

# Private subnets 
resource "aws_subnet" "demo_private_subnet_1" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "demo-private-subnet-1"
  }
}

resource "aws_subnet" "demo_private_subnet_2" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "demo-private-subnet-2"
  }
}

# DB subnet 
resource "aws_subnet" "demo_db_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.db_subnet_cidr
  availability_zone = var.azs[1]

  tags = {
    Name = "demo-db-subnet"
  }
}


# Internet Gateway

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo-igw"
  }
}


# Public Route Table

resource "aws_route_table" "demo_public_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name = "demo-public-rt"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "demo_public_rt_assoc" {
  subnet_id      = aws_subnet.demo_public_subnet.id
  route_table_id = aws_route_table.demo_public_rt.id
}
