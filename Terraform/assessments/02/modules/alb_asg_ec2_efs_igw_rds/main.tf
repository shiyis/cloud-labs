###### VPC CONFIG ######

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-vpc"
  }

}

### ROUTE TABLE DATA ###

data "aws_route_table" "route_table" {
  filter {
    name   = "association.main"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
}

#Create subnet # 1
resource "aws_subnet" "subnet0" {
  availability_zone = element(var.az_names, 0)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
}

#Create subnet # 2
resource "aws_subnet" "subnet1" {
  availability_zone = element(var.az_names, 1)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
}

#Create subnet # 3
resource "aws_subnet" "subnet2" {
  availability_zone = element(var.az_names, 2)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
}

#Create subnet # 4
resource "aws_subnet" "subnet3" {
  availability_zone = element(var.az_names, 3)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
}