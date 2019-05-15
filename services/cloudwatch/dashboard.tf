resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "my-kafka-test-dashboard"
  provider = "aws.app"
  dashboard_body = <<EOF
  {
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 9,
            "width": 12,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics", "Metric", "MessagesInPerSec", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ]
                ],
                "region": "${var.region}",
                "period": 300,
                "title": "KafkaMessagesInPerSecond",
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 9,
            "width": 6,
            "height": 12,
            "properties": {
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics", "Metric", "MessagesInPerSec", "HostName", "${var.hostname_4}", { "stat": "Average" } ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ]
                ],
                "view": "singleValue",
                "stacked": true,
                "region": "${var.region}",
                "title": "KafkaMessagesInPerSecond_Count",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 9,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Value", "MetricType", "KafkaController", "Metric", "ActiveControllerCount", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ]
                ],
                "region": "${var.region}",
                "title": "KafkaActiveControllerCount"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 21,
            "width": 12,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics", "Metric", "BytesInPerSec", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_2}" ]
                ],
                "region": "${var.region}",
                "title": "KafkaBytesInPerSecond"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 21,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics", "Metric", "BytesInPerSec", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_2}" ]
                ],
                "region": "${var.region}",
                "period": 300,
                "title": "KafkaBytesInCount"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 21,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Value", "MetricType", "KafkaController", "Metric", "OfflinePartitionsCount", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_2}" ]
                ],
                "region": "${var.region}",
                "title": "OfflinePartitionCount"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 33,
            "width": 12,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics", "Metric", "BytesOutPerSec", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_2}" ]
                ],
                "region": "${var.region}",
                "title": "KafkaBytesOutPerSecond"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 33,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics", "Metric", "BytesOutPerSec", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_2}" ]
                ],
                "region": "${var.region}",
                "title": "KafkaBytesOutCount"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 33,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Value", "MetricType", "ReplicaManager", "Metric", "UnderReplicatedPartitions", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_2}" ]
                ],
                "region": "${var.region}",
                "title": "KafkaUnderReplicationPartitionCount"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 0,
            "width": 12,
            "height": 9,
            "properties": {
                "metrics": [
                    [ "Kafka", "HeapMemoryUsage_used", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_2}" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 45,
            "width": 18,
            "height": 9,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_PROC_IN", "Metric", "MessagesInPerSec_PROC_IN", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec PROC_IN"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 63,
            "width": 18,
            "height": 9,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_DISP_IN", "Metric", "MessagesInPerSec_DISP_IN", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec DISP_IN"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 54,
            "width": 18,
            "height": 9,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_RSD_IN", "Metric", "MessagesInPerSec_RSD_IN", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec RSD_IN"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 45,
            "width": 6,
            "height": 9,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_PROC_IN", "Metric", "MessagesInPerSec_PROC_IN", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "period": 300,
                "title": "PROC_COUNT"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 54,
            "width": 6,
            "height": 9,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_RSD_IN", "Metric", "MessagesInPerSec_RSD_IN", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "period": 300,
                "title": "RSD_COUNT"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 63,
            "width": 6,
            "height": 9,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_DISP_IN", "Metric", "MessagesInPerSec_DISP_IN", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "period": 300,
                "title": "DISP_IN"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 72,
            "width": 18,
            "height": 9,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_1", "Metric", "MessagesInPerSec_TARGET_TOPIC_1", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec TARGET_TOPIC_1"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 72,
            "width": 6,
            "height": 9,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_1", "Metric", "MessagesInPerSec_TARGET_TOPIC_1", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "period": 300,
                "title": "TARGET_TOPIC_1"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 81,
            "width": 18,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_2", "Metric", "MessagesInPerSec_TARGET_TOPIC_2", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "period": 300,
                "title": "MessagesInPerSec TARGET_TOPIC_2"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 81,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_2", "Metric", "MessagesInPerSec_TARGET_TOPIC_2", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "period": 300,
                "title": "TARGET_TOPIC_2"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 93,
            "width": 18,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_3", "Metric", "MessagesInPerSec_TARGET_TOPIC_3", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec TARGET_TOPIC_3"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 93,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_3", "Metric", "MessagesInPerSec_TARGET_TOPIC_3", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "period": 300,
                "title": "TARGET_TOPIC_3"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 105,
            "width": 18,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_4", "Metric", "MessagesInPerSec_TARGET_TOPIC_4", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec TARGET_TOPIC_4"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 105,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_4", "Metric", "MessagesInPerSec_TARGET_TOPIC_4", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_2}" ]
                ],
                "region": "${var.region}",
                "title": "TARGET_TOPIC_4"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 117,
            "width": 18,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_5", "Metric", "MessagesInPerSec_TARGET_TOPIC_5", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "MesssagesInPerSec TARGET_TOPIC_5"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 117,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_5", "Metric", "MessagesInPerSec_TARGET_TOPIC_5", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "TARGET_TOPIC_5"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 129,
            "width": 18,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_6", "Metric", "MessagesInPerSec_TARGET_TOPIC_6", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec TARGET_TOPIC_6"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 129,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_6", "Metric", "MessagesInPerSec_TARGET_TOPIC_6", "HostName", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_2}" ]
                ],
                "region": "${var.region}",
                "title": "TARGET_TOPIC_6"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 141,
            "width": 18,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_7", "Metric", "MessagesInPerSec_TARGET_TOPIC_7", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec TARGET_TOPIC_7"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 141,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_7", "Metric", "MessagesInPerSec_TARGET_TOPIC_7", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "TARGET_TOPIC_7"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 153,
            "width": 18,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_8", "Metric", "MessagesInPerSec_TARGET_TOPIC_8", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec TARGET_TOPIC_8"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 153,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_8", "Metric", "MessagesInPerSec_TARGET_TOPIC_8", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "TARGET_TOPIC_8"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 165,
            "width": 18,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_9", "Metric", "MessagesInPerSec_TARGET_TOPIC_9", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec TARGET_TOPIC_9"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 165,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_9", "Metric", "MessagesInPerSec_TARGET_TOPIC_9", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "TARGET_TOPIC_9"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 177,
            "width": 18,
            "height": 12,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "Kafka", "OneMinuteRate", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_10", "Metric", "MessagesInPerSec_TARGET_TOPIC_10", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_4}" ],
                    [ "...", "${var.hostname_3}" ]
                ],
                "region": "${var.region}",
                "title": "MessagesInPerSec TARGET_TOPIC_10"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 177,
            "width": 6,
            "height": 12,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "Kafka", "Count", "MetricType", "BrokerTopicMetrics_TARGET_TOPIC_10", "Metric", "MessagesInPerSec_TARGET_TOPIC_10", "HostName", "${var.hostname_2}" ],
                    [ "...", "${var.hostname_1}" ],
                    [ "...", "${var.hostname_3}" ],
                    [ "...", "${var.hostname_4}" ]
                ],
                "region": "${var.region}",
                "title": "TARGET_TOPIC_10"
            }
        }
    ]
}
 EOF
}
