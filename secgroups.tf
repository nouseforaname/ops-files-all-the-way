resource "aws_security_group" "deployment_2" {
  name        = "deployment_1"
  description = "Allow all inbound traffic"
  vpc_id     = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "deployment_1" {
  name        = "deployment_2"
  description = "Allow all inbound traffic"
  vpc_id     = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "null_resource" "cloud_config_vm_extensions" {
  depends_on = ["aws_security_group.deployment_1","aws_security_group.deployment_2"]
  provisioner "local-exec" {
    command = "./cloud_config_vm_extension.sh"
  }
}

