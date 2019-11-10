output "sg_external_subnet_sg_id" {
  value = aws_security_group.sg_external_subnet.id
}

output "sg_internal_subnet_sg_id" {
  value = aws_security_group.sg_internal_subnet.id
}

output "sg_secured_subnet_sg_id" {
  value = aws_security_group.sg_secured_subnet.id
}
