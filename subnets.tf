resource "aws_subnet" "main" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "172.31.0.0/24"

  tags {
    Name = "Main"
  }
}

resource "aws_subnet" "deployment_az_1" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "172.31.1.0/24"
  availability_zone= "eu-central-1a"
  tags {
    Name = "Deployment_az_1"
  }
}
resource "aws_subnet" "deployment_az_2" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "172.31.2.0/24"

  availability_zone= "eu-central-1b"
  tags {
    Name = "Deployment_az_2"
  }
}
resource "aws_subnet" "deployment_az_3" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "172.31.3.0/24"

  availability_zone= "eu-central-1c"
  tags {
    Name = "Deployment_az_3"
  }
}

resource "null_resource" "cloud_config_networks" {
  depends_on = ["aws_subnet.deployment_az_1","aws_subnet.deployment_az_2","aws_subnet.deployment_az_3"]
  provisioner "local-exec" {
    command = "./cloud_config.sh"
  }
}

