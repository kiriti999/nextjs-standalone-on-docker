resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "ed25519_key" {
  algorithm = "ED25519"
}

#  create key pair for connecting to EC2 via SSH
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ed25519_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.ed25519_key.private_key_openssh
  filename = pathexpand("~/.ssh/${var.private_key}")
  provisioner "local-exec" {
    command = "chmod 600 ${self.filename}"
  }
}
