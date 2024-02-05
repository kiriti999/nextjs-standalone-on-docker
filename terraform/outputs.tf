output "public_ip" {
  value = module.ec2_instance.public_ip
}

output "instance_id" {
  value = module.ec2_instance.id
}

output "ssh_private_key" {
  value = local_file.private_key.filename
}

output "ssh_connect_string" {
  value = "ssh -i ${local_file.private_key.filename} ec2-user@${module.ec2_instance.public_ip}"
}

output "app_version_string" {
  value = var.prod_image_version
}