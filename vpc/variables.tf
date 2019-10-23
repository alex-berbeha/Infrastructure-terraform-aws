variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "172.20.0.0/16"
}

variable "vpc_cidr_external" {
  description = "CIDR for the external subnet"
  default     = "172.20.0.0/24"
}

variable "vpc_cidr_internal" {
  description = "CIDR for the internal subnet"
  default     = "172.20.1.0/24"
}

variable "vpc_cidr_secured" {
  description = "CIDR for the secured subnet"
  default     = "172.20.2.0/24"
}

variable "aws_region" {
  description = "region"
  default     = "us-east-2"
}
