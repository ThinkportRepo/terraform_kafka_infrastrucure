resource "aws_network_interface" "kafka_eni" {
  provider = "aws.app"
  count        = "${data.aws_subnet.subnet.count * 2}"
  subnet_id    = "${var.subnets[count.index % data.aws_subnet.subnet.count]}"
  private_ips  = ["${cidrhost(element(data.aws_subnet.subnet.*.cidr_block, count.index), 32 + count.index)}"]
  security_groups = [
    "${aws_security_group.internal-security-group.id}",
    "${aws_security_group.ssh-security-group.id}"
  ]
  tags {
    Name = "kafka-eni"
  }
}
