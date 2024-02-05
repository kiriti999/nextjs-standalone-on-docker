data "aws_vpc" "existing_vpc" {
  tags = {
    Name = "skillpact-vpc"
  }
}

data "aws_subnets" "existing_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
}

data "aws_iam_instance_profile" "existing_instance_profile" {
  name = "skillpact-ec2-instance-profile"
}

module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  associate_public_ip_address = true
  ami                         = var.ami
  name                        = var.instance_name
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.existing_vpc_subnets.ids[0]
  key_name                    = aws_key_pair.key_pair.key_name
  monitoring                  = true
  vpc_security_group_ids      = [data.aws_security_group.existing_sg.id]
  user_data                   = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    yum install -y jq
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user
  EOF  

  iam_instance_profile = data.aws_iam_instance_profile.existing_instance_profile.name

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = var.instance_name
  }
}

resource "null_resource" "boot_finished" {
  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 5; done",
    ]
    connection {
      type        = "ssh"
      host        = module.ec2_instance.public_ip
      user        = "ec2-user"
      private_key = tls_private_key.ed25519_key.private_key_openssh
    }
  }
}
