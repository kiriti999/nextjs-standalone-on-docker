resource "null_resource" "node_provisioner" {
  depends_on = [null_resource.boot_finished]
  triggers = {
    instance_id = module.ec2_instance.id
  }
  connection {
    host        = module.ec2_instance.public_ip
    user        = "ec2-user"
    type        = "ssh"
    private_key = local_file.private_key.content
  }
}

resource "null_resource" "image_updater" {

  depends_on = [null_resource.node_provisioner, null_resource.boot_finished]
  triggers = {
    image_version = var.env_name == "dev" ? var.dev_image_version : var.prod_image_version
    test          = "v2"
  }
  connection {
    host        = module.ec2_instance.public_ip
    user        = "ec2-user"
    type        = "ssh"
    private_key = local_file.private_key.content
  }
  provisioner "file" {
    source      = "run-image.sh"
    destination = "run-image.sh"
  }
  provisioner "file" {
    source      = "../.env.${var.env_name}"
    destination = ".env.${var.env_name}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x run-image.sh",
      "if [ \"${var.env_name}\" == \"dev\" ]; then",
      "  ./run-image.sh \"${var.dev_image_version}\" \"${var.port}\"",
      "else",
      "  ./run-image.sh \"${var.prod_image_version}\" \"${var.port}\"",
      "fi"
    ]
  }
}
