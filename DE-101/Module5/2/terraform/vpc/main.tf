terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.39.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "akv-vpc" {
  cidr_block       = "10.60.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "akv-vpc"
  }
}

resource "aws_internet_gateway" "akv-igw" {
  vpc_id = aws_vpc.akv-vpc.id

  tags = {
    Name = "akv-igw"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "akv-public-subnet" {
  vpc_id     = aws_vpc.akv-vpc.id
  cidr_block = "10.60.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "akv-public-subnet"
  }
}

resource "aws_subnet" "akv-private-subnet" {
  vpc_id     = aws_vpc.akv-vpc.id
  cidr_block = "10.60.2.0/24"
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "akv-private-subnet"
  }
}

resource "aws_route_table" "akv-public-route-table" {
  vpc_id = aws_vpc.akv-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.akv-igw.id
  }

  tags = {
    Name = "akv-public-route-table"
  }
}

resource "aws_route_table_association" "akv-public-subnet-route-table-association" {
  subnet_id      = aws_subnet.akv-public-subnet.id
  route_table_id = aws_route_table.akv-public-route-table.id
}
