provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket = "iaac-terraform-aws"
    key    = "dev/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_vpc" "vpc2130" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    Name = "vpc2130"
  }
}

resource "aws_internet_gateway" "IGW2130" {
  vpc_id = aws_vpc.vpc2130.id
  tags = {
    Name = "IGW2130"
  }
}

resource "aws_subnet" "external_subnet" {
  vpc_id            = aws_vpc.vpc2130.id
  cidr_block        = "${var.vpc_cidr_external}"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "external_subnet"
  }
}

resource "aws_subnet" "internal_subnet" {
  vpc_id                  = aws_vpc.vpc2130.id
  cidr_block              = "${var.vpc_cidr_internal}"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "internal_subnet"
  }
}

resource "aws_subnet" "secured_subnet" {
  vpc_id            = aws_vpc.vpc2130.id
  cidr_block        = "${var.vpc_cidr_secured}"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "secured_subnet"
  }
}

resource "aws_eip" "eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.IGW2130"]
}

resource "aws_nat_gateway" "NAT_gateway" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${aws_subnet.internal_subnet.id}"
  depends_on    = ["aws_internet_gateway.IGW2130"]
  tags = {
    Name = "NAT_for_internal_subnet"
  }
}

resource "aws_route_table" "external_subnets" {
  vpc_id = aws_vpc.vpc2130.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW2130.id
  }
  tags = {
    Name = "route-external-subnet"
  }
}

resource "aws_route_table_association" "external_routes" {
  route_table_id = aws_route_table.external_subnets.id
  subnet_id      = aws_subnet.external_subnet.id
}

resource "aws_route_table" "internal_subnets" {
  vpc_id = aws_vpc.vpc2130.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_gateway.id
  }
  tags = {
    Name = "route-external-subnet"
  }
}

resource "aws_route_table_association" "internal_routes" {
  route_table_id = aws_route_table.internal_subnets.id
  subnet_id      = aws_subnet.internal_subnet.id
}
