output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.main_vpc.id
}

output "main_app_subnet_id" {
    description = "App Subnets IDs"
    value = aws_subnet.main_subnet.id
} 

output "main_sg_id" {
    description = "Default SG ID VPC"
    value = aws_security_group.main_sgrp.id
  
}