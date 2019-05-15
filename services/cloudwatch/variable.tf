variable "hostname_1" {
  default = "10.0.0.32"
}

variable "hostname_2" {
  default = "10.0.0.34"
}

variable "hostname_3" {
  default = "10.0.0.161"
}

variable "hostname_4" {
  default = "10.0.0.163"
}

variable "region" {
  default = "eu-central-1"
}

variable "alarms_email" {
  default = "akadyrov@thinkport.digital"
}

variable "private_dns_list" {
  type = "list"
  default = ["10.0.0.32","10.0.0.34","10.0.0.161","10.0.0.163"]
}
