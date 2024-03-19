###
### VPC variables
###

variable "vpc_cidr" {
    description = "(Required) the AWS VPC CIDR block"
    type = string
}

variable "region_name" {
    description = "(Required) region name"
    type = string
}

variable "environment_name" {
    description = "(Required) environment name"
    type = string
}
variable "vpc_subnets" {
    description = "(Required) A mapping of aws subnets"
    type = map
}





