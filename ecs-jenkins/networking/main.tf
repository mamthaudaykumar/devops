# Variable for project prefix
variable "project_prefix" {}
variable "eu_availability_zone" {}

variable "cidr_public_subnet" {}

variable "cidr_private_subnet" {}
variable "vpc_cidr" {}

# VPC
resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_prefix}-ecs-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "ecs_public_subnet" {
  count             = length(var.cidr_public_subnet)
  vpc_id                  = aws_vpc.ecs_vpc.id
  map_public_ip_on_launch = true
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "${var.project_prefix}-ecs-public-subnet-${count.index + 1}"
    Type = "public"
  }
}

# Private Subnets
resource "aws_subnet" "ecs_private_subnet" {
  count             = length(var.cidr_private_subnet)
  vpc_id                  = aws_vpc.ecs_vpc.id
  map_public_ip_on_launch = false
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "${var.project_prefix}-ecs-private-subnet-${count.index + 1}"
    Type = "private"
  }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "ecs_public_internet_gateway" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags = {
    Name = "${var.project_prefix}-igw"
  }
}

# Public Route Table
resource "aws_route_table" "ecs_public_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_public_internet_gateway.id
  }
  tags = {
    Name = "${var.project_prefix}-public-rt"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "ecs_public_rt_association" {
  count          = length(aws_subnet.ecs_public_subnet)
  subnet_id      = aws_subnet.ecs_public_subnet[count.index].id
  route_table_id = aws_route_table.ecs_public_route_table.id
}

# Private Route Table
resource "aws_route_table" "ecs_private_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags = {
    Name = "${var.project_prefix}-private-rt"
  }
}

# Private Route Table and Private Subnet Association
resource "aws_route_table_association" "ecs_private_rt_association" {
  count          = length(aws_subnet.ecs_private_subnet)
  subnet_id      = aws_subnet.ecs_private_subnet[count.index].id
  route_table_id = aws_route_table.ecs_private_route_table.id
}
