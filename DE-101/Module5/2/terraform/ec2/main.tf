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

locals {
  prefix = "akv"
}

data "aws_vpc" "akv-vpc" {
  filter {
    name   = "tag:Name"
    values = ["${local.prefix}-vpc"]
  }
}

data "aws_subnet" "akv-private-subnet" {
  vpc_id      = data.aws_vpc.akv-vpc.id

  filter {
    name   = "tag:Name"
    values = ["${local.prefix}-private-subnet"]
  }
}

data "aws_subnet" "akv-public-subnet" {
  vpc_id      = data.aws_vpc.akv-vpc.id

  filter {
    name   = "tag:Name"
    values = ["${local.prefix}-public-subnet"]
  }
}

resource "aws_security_group" "akv-public-sg" {
  name        = "akv-public-sg"
  description = "Allow public access with ssh(22)"
  vpc_id      = data.aws_vpc.akv-vpc.id

  ingress {
    description = "Allow public access with ssh(22)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "${local.prefix}-public-sg"
  }
}

resource "aws_security_group" "akv-private-sg" {
  name        = "${local.prefix}-private-sg"
  description = "Allow public access with ssh(22)"
  vpc_id      = data.aws_vpc.akv-vpc.id

  ingress {
    description = "Allow ssh(22) access only from public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.60.1.0/24"] # 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "${local.prefix}-private-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "tls_private_key" "akv-pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "akv-kp" {
  key_name   = "akv-key"       # Create "myKey" to AWS!!
  public_key = tls_private_key.akv-pk.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.akv-pk.private_key_pem}' > ./akv-key.pem"
  }
}

resource "aws_instance" "public-ec2-instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.akv-public-subnet.id
  vpc_security_group_ids = [aws_security_group.akv-public-sg.id] 
  key_name        = aws_key_pair.akv-kp.key_name

  tags = {
    Name = "${local.prefix}-public-ec2-instance"
  }
}

resource "aws_instance" "private-ec2-instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.akv-private-subnet.id
  vpc_security_group_ids = [aws_security_group.akv-private-sg.id]
  key_name        = aws_key_pair.akv-kp.key_name

  tags = {
    Name = "${local.prefix}-private-ec2-instance"
  }
}


