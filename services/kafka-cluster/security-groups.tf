resource "aws_security_group" "ssh-security-group" {
  provider = "aws.app"
  name_prefix = "ssh-woodmark-bmw-"
  description = "allow ssh access from everywhere"
  vpc_id = "${var.vpc_id}"
  ingress {
    cidr_blocks = "${var.allowed_ingress_list}"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  egress {
    cidr_blocks = "${var.allowed_egress_list}"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags {
    Name = "ssh-woodmark-bmw-sg"
  }
}

resource "aws_security_group" "internal-security-group" {
  provider = "aws.app"
  name_prefix = "internal-woodmark-bmw-"
  description = "allow ssh access from internal"
  vpc_id = "${var.vpc_id}"
  ingress {
    cidr_blocks = ["${var.cidr_vpc}"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  egress {
    cidr_blocks = "${concat(var.allowed_egress_list, list(var.cidr_vpc))}"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags {
    Name = "ssh-woodmark-bmw-sg"
  }
}
