data "aws_subnet" "subnet" {
  provider = "aws.app"
  count = "${length(var.subnets)}"
  id = "${var.subnets[count.index]}"
}

data "aws_ami" "kafka-ami" {
  provider = "aws.app"
  owners   = ["self"]
  most_recent = true

  filter {
    name = "name"
    values = ["packer-base-kafka-*"]
  }
}
