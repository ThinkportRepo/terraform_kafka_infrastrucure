resource "aws_cloudwatch_metric_alarm" "kafka-active-controller-alarm" {
  provider = "aws.app"
  count = "${length(var.private_dns_list)}"
  alarm_name = "OFFLINE-PARTITION-KAFKA-${var.private_dns_list[count.index]}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "5"
  namespace = "Kafka"
  metric_name = "Value"
  period = "60"
  statistic = "Average"
  threshold = "0"
  alarm_actions = [ "${aws_sns_topic.alarm.arn}" ]
  dimensions {
    MetricType = "KafkaController"
    Metric = "OfflinePartitionsCount"
    HostName = "${var.private_dns_list[count.index]}"
  }
}

resource "aws_cloudwatch_metric_alarm" "kafka-under-replicated-alarm" {
  provider = "aws.app"
  count = "${length(var.private_dns_list)}"
  alarm_name = "UNDERREPILICATED-PARTITION-KAFKA-${var.private_dns_list[count.index]}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "5"
  namespace = "Kafka"
  metric_name = "Value"
  period = "60"
  statistic = "Average"
  threshold = "0"
  alarm_actions = [ "${aws_sns_topic.alarm.arn}" ]
  dimensions {
    MetricType = "ReplicaManager"
    Metric = "UnderReplicatedPartitions"
    HostName = "${var.private_dns_list[count.index]}"
  }
}
