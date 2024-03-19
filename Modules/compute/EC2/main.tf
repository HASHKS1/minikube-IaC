resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = format(
              "${path.module}/PKI/%s-%s-pki.pem",
              lower(var.application_name),
              lower(var.environment_name),
        )
}

resource "aws_key_pair" "generated" {
  lifecycle {
    create_before_destroy = true
  }
  key_name   = format(
            "%s-%s-pki",
            lower(var.application_name),
            lower(var.environment_name),
        )
  public_key = tls_private_key.generated.public_key_openssh
}

resource "aws_instance" "ec2_server" {
    depends_on = [
        var.subnet_ids
    ]
    instance_type = var.instance_type
    ami = data.aws_ami.server_ami.id
    key_name = aws_key_pair.generated.id
    subnet_id = var.subnet_ids
    vpc_security_group_ids = [aws_security_group.ec2_server.id]
    disable_api_termination = true
    user_data = file("${path.module}/userdata/startupcmd-minikube.sh")

    root_block_device {
        volume_size = 20
    }

    tags =  {
        Name = format(
            "server-%s-%s",
            lower(var.application_name),
            lower(var.environment_name),
        )
        Environment = lower(var.environment_name)
    }

}

resource "aws_security_group" "ec2_server" {
    description = format(
        "sg-ec2-%s-%s",
        lower(var.environment_name),
        lower(var.application_name)
    )
    lifecycle {
        create_before_destroy = true
    }
    name = format(
        "sgrg-ec2-%s-%s",
        lower(var.application_name),
        lower(var.environment_name)
    )
    revoke_rules_on_delete = true
    tags = {
        Name = format(
            "sg-ec2-%s-%s",
            lower(var.application_name),
            lower(var.environment_name)
        )
        Environment = lower(var.environment_name)
    }
    vpc_id = var.vpc_id
}

# Minikube SG for dev env, must open only necessary ports in prod
### Egress Rules
resource "aws_security_group_rule" "ec2_sgrp_all_egress" {
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description = "All Traffic"
  from_port   = 0
  ipv6_cidr_blocks = [
    "::/0"
  ]
  protocol          = "-1"
  security_group_id = aws_security_group.ec2_server.id
  to_port           = 0
  type              = "egress"
}

### Ingress Rules
resource "aws_security_group_rule" "ec2_sgrp_all_ingress" {
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description = "All Traffic"
  from_port   = 0
  ipv6_cidr_blocks = [
    "::/0"
  ]
  protocol          = "-1"
  security_group_id = aws_security_group.ec2_server.id
  to_port           = 0
  type              = "ingress"
}

