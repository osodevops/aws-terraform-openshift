output "bastion_ip_address" {
  value = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}

output "bastion_public_ssh_key" {
  value = aws_instance.bastion.key_name
}