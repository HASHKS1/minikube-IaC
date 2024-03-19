variable "aws_default_region" {
  type    = string
  default = "eu-west-3"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/22"
}

variable "environment" {
  default = "DEV"
  type    = string
}

variable "vpc_subnets" {
  type = map(any)
  default = {
    "az1" : {
      "az_name" : "eu-west-3a",
      "app_cidr" : "10.0.0.0/24"
    }
  }
}

variable "instance_ec2_type" {
  type    = string
  default = "t3.small"
}