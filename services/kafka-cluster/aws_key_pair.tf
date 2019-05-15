resource "aws_key_pair" "bastion-bmw-key2" {
  provider = "aws.app"
  key_name = "bastion-bmw-key2"
  public_key = "${file("${path.cwd}/kafka-cluster/keys/bastion-bmw-key2.pub")}"
}
