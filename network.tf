# ---------------------------------
# VPC
# ---------------------------------

resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------------
# Subnet
# ---------------------------------

resource "aws_subnet" "public_subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-1a"
    Project = var.project
    Env     = var.environment
    Typen   = "public"
  }
}

resource "aws_subnet" "public_subnet-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-1c"
    Project = var.project
    Env     = var.environment
    Typen   = "public"
  }
}

resource "aws_subnet" "private_subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-1a"
    Project = var.project
    Env     = var.environment
    Typen   = "private"
  }
}

resource "aws_subnet" "private_subnet-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-1c"
    Project = var.project
    Env     = var.environment
    Typen   = "private"
  }
}

# ---------------------------------
# Route Table
# ---------------------------------

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-public-rt"
    Project = var.project
    Env     = var.environment
    Typen   = "public"
  }
}

resource "aws_route_table_association" "public-rt-1a" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public_subnet-1a.id
}

resource "aws_route_table_association" "public-rt-1c" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public_subnet-1c.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-rt"
    Project = var.project
    Env     = var.environment
    Typen   = "private"
  }
}

resource "aws_route_table_association" "private-rt-1a" {
  route_table_id = aws_route_table.private-rt.id
  subnet_id      = aws_subnet.private_subnet-1a.id
}

resource "aws_route_table_association" "private-rt-1c" {
  route_table_id = aws_route_table.private-rt.id
  subnet_id      = aws_subnet.private_subnet-1c.id
}

# ---------------------------------
# Internet Gateway
# ---------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "pulic-rt-igw-r" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

}