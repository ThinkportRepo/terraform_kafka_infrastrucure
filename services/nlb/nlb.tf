resource "aws_lb" "kafka_erd_lb" {
  provider = "aws.app"
  name               = "kafka-lb"
  internal = true
  load_balancer_type = "network"
  subnets = "${var.subnets}"

  enable_deletion_protection = false
  tags {
    Name = "peering-nlb-kafka"
  }
}

resource "aws_lb_target_group" "kafka_lb_tg" {
  provider = "aws.app"
  name     = "kafka-lb-tg"
  port     = 9092
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = "${var.vpc_id}"
}


resource "aws_lb_listener" "kafka_listener" {
  provider = "aws.app"
  load_balancer_arn = "${aws_lb.kafka_erd_lb.arn}"
  port              = 9092
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.kafka_lb_tg.arn}"
  }
}
