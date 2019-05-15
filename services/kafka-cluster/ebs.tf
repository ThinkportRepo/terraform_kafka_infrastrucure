resource "aws_ebs_volume" "kafka_ebs_volumes" {
  provider          = "aws.app"
  count             = "${data.aws_subnet.subnet.count * 2}"
  availability_zone = "${element(data.aws_subnet.subnet.*.availability_zone, count.index)}"
  size              = 40
  type              = "standard"
  tags = {
    Name = "kafka-ebs-volumes-"
  }
}

# resource "aws_volume_attachment" "attach" {
#   count = "${aws_instance.kafka-server.count}"
#   device_name = "/dev/xvdf"
#   volume_id = "${element(aws_ebs_volume.example.*.volume_id, count.index)}"
#   instance_id = "${element(aws_instance.kafka-server.*.id, count.index)}"
# }
