data "template_file" "user_data_kafka" {
  template = "${file("${path.cwd}/kafka-cluster/templates/user_data_kafka.sh")}"

  vars = {
    region = "${var.region}"
  }

}
