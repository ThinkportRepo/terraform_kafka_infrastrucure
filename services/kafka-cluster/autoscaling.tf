resource "aws_launch_configuration" "kafka_launch_configuration" {
  provider        = "aws.app"
  name_prefix     = "terraform-kafka-launchconfig"
  image_id        = "${data.aws_ami.kafka-ami.id}"
  instance_type   = "${var.kafka_instance_type}"
  key_name        = "bastion-bmw-key2"
  user_data = "${data.template_file.user_data_kafka.rendered}"

  iam_instance_profile = "${aws_iam_instance_profile.kafka_profile.name}"

  security_groups = [
    "${aws_security_group.internal-security-group.id}",
    "${aws_security_group.ssh-security-group.id}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "kafka_autoscaling_group" {
  provider             = "aws.app"
  name                 = "kafka_autoscaling_group"
  launch_configuration = "${aws_launch_configuration.kafka_launch_configuration.name}"
  desired_capacity     = 4
  min_size             = 4
  max_size             = 4
  vpc_zone_identifier  = "${var.subnets}"

  tags = [
    {
      key                 = "Name"
      value               = "kafka-node"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}
