variable "aws_region" {
  description = "region"
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_external" {
  description = "CIDR for the external subnet"
  default     = "10.0.0.0/24"
}

variable "vpc_cidr_internal" {
  description = "CIDR for the internal subnet"
  default     = "10.0.1.0/24"
}

variable "vpc_cidr_secured" {
  description = "CIDR for the secured subnet"
  default     = "10.0.2.0/24"
}
