variable "allows_ports" {
  description = "allowed ingress ports"
  default     = ["80", "443", "22"]
}

variable "aws_region" {
  description = "region"
  default     = "us-east-2"
}
