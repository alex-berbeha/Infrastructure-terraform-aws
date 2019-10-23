provider "aws" {
  region = "us-east-2"
}

#create vpc
resource "aws_vpc" "vpc2122" {
  cidr_block                       = "${var.vpc_cidr}"
  instance_tenancy                 = "default"
  enable_dns_support               = "true"
  enable_dns_hostnames             = "true"
  assign_generated_ipv6_cidr_block = "false"
  enable_classiclink               = "false"
  tags = {
    Name = "vpc2122"
  }
}

#create Internet gateway
resource "aws_internet_gateway" "gateway-2122" {
  vpc_id = "${aws_vpc.vpc2122.id}"
  tags = {
    Name = "InternetGateway-2122"
  }
}

#create external subnet
resource "aws_subnet" "aws-subnet-external" {
  vpc_id                  = "${aws_vpc.vpc2122.id}"
  cidr_block              = "${var.vpc_cidr_external}"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "external subnet"
  }
}

#create internal subnet
resource "aws_subnet" "aws-subnet-internal" {
  vpc_id            = "${aws_vpc.vpc2122.id}"
  cidr_block        = "${var.vpc_cidr_internal}"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "internal subnet"
  }
}

##create secured subnet
resource "aws_subnet" "aws-subnet-secured" {
  vpc_id            = "${aws_vpc.vpc2122.id}"
  cidr_block        = "${var.vpc_cidr_secured}"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "secured subnet"
  }
}

## Elastic IP for NAT GW
resource "aws_eip" "eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gateway-2122"]
}


## NAT gateway
resource "aws_nat_gateway" "gateway" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${aws_subnet.aws-subnet-internal.id}"
  depends_on    = ["aws_internet_gateway.gateway-2122"]
}
