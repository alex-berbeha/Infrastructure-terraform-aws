provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket = "iaac-terraform-aws"
    key    = "dev/instances/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "iaac-terraform-aws"
    key    = "dev/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "security-group" {
  backend = "s3"
  config = {
    bucket = "iaac-terraform-aws"
    key    = "dev/security-group/terraform.tfstate"
    region = "us-east-2"
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "key-ohio" {
  key_name   = "key-ohio"
  public_key = "${var.key-ohio}"
}

resource "aws_instance" "external_server_linux_amazon" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.terraform_remote_state.security-group.outputs.sg_external_subnet_sg_id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.external_subnet_id
  key_name               = "key-ohio"
  tags = {
    Name = "Server in external subnet"
  }
}
