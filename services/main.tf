provider "aws" {
  access_key = "AKIAIPBHG4H3J4YBOROA"
  secret_key = "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"
  region     = "eu-central-1"
  alias      = "app"
}

terraform {
  backend "s3" {
    bucket = "terraformbucket-kafka1"
    key    = "Kafka_new/terraform.tfstate"
    region = "eu-central-1"
    access_key = "AKIAIPBHG4H3J4YBOROA"
    secret_key = "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"
  }
}

module "kafka" {
  source = "./kafka-cluster"

  environment = "my-env"
  app_name = "kafka"

  region = "eu-central-1"

  subnets = ["subnet-0dc077ed134195992", "subnet-09b3adfd4e4be727f"]

  allowed_ingress_list = ["0.0.0.0/0"]
  allowed_egress_list  = ["0.0.0.0/0"]

  cidr_vpc = "10.0.0.0/24"
  vpc_id = "vpc-03828dee0a9bfcc5a"

  burrow_ami = "ami-09def150731bdbcc2"

  kafka_instance_type = "m4.large"

  kafka_autoscaling_policy_arn = "arn:aws:iam::229176864149:policy/kafka_autoscaling_policy"

  providers {
    aws.app = "aws.app"
  }
}

module "monitoring" {
  source = "./cloudwatch"

  providers {
    aws.app = "aws.app"
  }
}

module "nlb" {
  source = "./nlb"

  vpc_id = "vpc-03828dee0a9bfcc5a"
  subnets = ["subnet-0dc077ed134195992", "subnet-09b3adfd4e4be727f"]

}