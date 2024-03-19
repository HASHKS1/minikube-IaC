variable "instance_type" {
  type    = string
  description = "(Required) The parameter instance type"
}

variable "subnet_ids" {
    description = "(Required) The Subnets ID"
    type = string
}

variable "application_name" {
    description = "(Required) application name"
    type = string
}

variable "environment_name" {
    description = "(Required) environment name"
    type = string
}

variable "vpc_id" {
    description = "(Required) The AWS VPC ID"
    type = string
}
