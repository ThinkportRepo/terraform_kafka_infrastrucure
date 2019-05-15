variable "environment" {
  type = "string"
}

variable "app_name" {
  type = "string"
}

variable "subnets" {
  type = "list"
}

variable "allowed_ingress_list" {
  type = "list"
}

variable "allowed_egress_list" {
  type = "list"
}

variable "cidr_vpc" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "burrow_ami" {
  type = "string"
}

variable "kafka_instance_type" {
  type = "string"
}

variable "cluster_instance_iam_policy_contents" {
  description = "The contents fo the cluster instance IAM policy"
  default = ""
}

variable "region" {
  type = "string"
}

variable "kafka_autoscaling_policy_arn" {
  description = "arn of created policy"
}
