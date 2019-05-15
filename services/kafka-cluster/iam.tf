resource "aws_iam_instance_profile" "kafka_profile" {
  provider = "aws.app"
  path = "/"
  name = "kafka-ecs-profile"
  role = "${aws_iam_role.cluster_instance_role.name}"
}

resource "aws_iam_role" "cluster_instance_role" {
  provider           = "aws.app"
  name               = "kafka-ecs-role"
  assume_role_policy = "${file("${path.cwd}/kafka-cluster/policies/kafka_role.json")}"
}

resource "aws_iam_policy_attachment" "cluster_isntance_policy_attachment" {
  provider = "aws.app"
  name     = "kafka-ecs-attachment"
  roles = ["${aws_iam_role.cluster_instance_role.id}"]
  policy_arn = "${var.kafka_autoscaling_policy_arn}"
}
