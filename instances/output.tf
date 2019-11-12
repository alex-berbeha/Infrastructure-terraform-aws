output "external_server_linux_amazon_id" {
  value = aws_instance.external_server_linux_amazon.id
}

output "external_server_linux_amazon_private_ip" {
  value = aws_instance.external_server_linux_amazon.private_ip
}

output "external_server_linux_amazon_public_ip" {
  value = aws_instance.external_server_linux_amazon.public_ip
}
