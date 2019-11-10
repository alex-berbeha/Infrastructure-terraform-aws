output "vpc_id" {
  value = aws_vpc.vpc2130.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc2130.cidr_block
}

output "external_subnet_cidr" {
  value = aws_subnet.external_subnet.cidr_block
}

output "external_subnet_id" {
  value = aws_subnet.external_subnet.id
}

output "internal_subnet_cidr" {
  value = aws_subnet.internal_subnet.cidr_block
}

output "internal_subnet_id" {
  value = aws_subnet.internal_subnet.id
}

output "secured_subnet_cidr" {
  value = aws_subnet.secured_subnet.cidr_block
}

output "secured_subnet_id" {
  value = aws_subnet.secured_subnet.id
}

output "nat_ip" {
  value = aws_nat_gateway.NAT_gateway.public_ip
}
