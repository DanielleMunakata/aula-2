terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.16"
   }
 }

 required_version = ">= 1.2.0"
 
} 

provider "aws" {
 region = "us-east-1"
}

resource "aws_vpc" "vpc-lab01-sptech" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-lab01-sptech"
  }
}

resource "aws_subnet" "sub-az1-pub-lab01-sptech" {
  vpc_id     = aws_vpc.vpc-lab01-sptech.id
  cidr_block = "10.0.0.0/25"

  tags = {
    Name = "sub-az1-pub-lab01-sptech"
  }
}

resource "aws_subnet" "sub-az1-priv-lab01-sptech" {
  vpc_id     = aws_vpc.vpc-lab01-sptech.id
  cidr_block = "10.0.1.0/25"

  tags = {
    Name = "sub-az1-priv-lab01-sptech"
  }
}

resource "aws_internet_gateway" "igw_lab02-sptech" {
  vpc_id = aws_vpc.vpc-lab01-sptech.id

  tags = {
    Name = "igw_lab02-sptech"
  }
}

resource "aws_route_table" "rtb-lab02-sptech" {
  vpc_id = aws_vpc.vpc-lab01-sptech.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_lab02-sptech.id
  }

  tags = {
    Name = "rtb-lab02-sptech"
  }
}

resource "aws_route" "router_routetointernet" {
  route_table_id            = aws_route_table.rtb-lab02-sptech.id
  destination_cidr_block    = "10.0.0.0/10"
  gateway_id                = aws_internet_gateway.igw_lab02-sptech.id
}

resource "aws_route_table_association" "router_pub_association" {
  subnet_id      = aws_subnet.sub-az1-pub-lab01-sptech.id
  route_table_id = aws_route_table.rtb-lab02-sptech.id
  
}