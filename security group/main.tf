provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "iaac-terraform-aws"
    key    = "dev/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

terraform {
  backend "s3" {
    bucket = "iaac-terraform-aws"
    key    = "dev/security-group/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_security_group" "sg_external_subnet" {
  name   = "Security Group for external_subnet"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  dynamic "ingress" {
    for_each = "${var.allows_ports}"
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Group for external_subnet"
  }
}

resource "aws_security_group" "sg_internal_subnet" {
  name   = "Security Group for internal_subnet"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  dynamic "ingress" {
    for_each = "${var.allows_ports}"
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Group for internal_subnet"
  }
}

resource "aws_security_group" "sg_secured_subnet" {
  name   = "Security Group for secured_subnet"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  dynamic "ingress" {
    for_each = "${var.allows_ports}"
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [data.terraform_remote_state.vpc.outputs.internal_subnet_cidr]
    }
  }

  dynamic "egress" {
    for_each = "${var.allows_ports}"
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = [data.terraform_remote_state.vpc.outputs.internal_subnet_cidr]
    }
  }

  tags = {
    Name = "Security Group for secured_subnet"
  }
}
