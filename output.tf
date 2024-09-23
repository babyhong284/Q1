output "ec2_bastion_id" {
  value = ["${aws_instance.bastion.id}"]
}

output "ec2_bastion_ips" {
  value = ["${aws_instance.bastion.public_ip}"]
}

