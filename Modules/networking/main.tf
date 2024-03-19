resource "aws_vpc" "main_vpc" {
    assign_generated_ipv6_cidr_block = false
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    instance_tenancy = "default"
    tags = {
        Name = format(
            "vpc-%s-%s",
            lower(var.region_name),
            lower(var.environment_name)
        )
        Environment = lower(var.environment_name)
    } 
}


### Public Subnet - App

resource "aws_subnet" "main_subnet" {
    availability_zone = var.vpc_subnets["az1"]["az_name"]
    cidr_block = var.vpc_subnets["az1"]["app_cidr"]
    depends_on = [
        aws_vpc.main_vpc
    ]
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = format(
            "sbn-%s-%s-az1",
            lower(var.region_name),
            lower(var.environment_name)
        )
        Environment = lower(var.environment_name)
    }
}

### Internet Gateway

resource "aws_internet_gateway" "main_igw" {
    depends_on = [
        aws_vpc.main_vpc
    ]
    
    tags = {
        Name = format(
            "main-igw-%s",
            lower(var.environment_name)
        )
        Environment = lower(var.environment_name)
    }
    vpc_id = aws_vpc.main_vpc.id
}

### DHCP Options Set
resource "aws_vpc_dhcp_options" "dhcp_main" {
    domain_name = "eu-west-3.compute.internal"
    domain_name_servers = [
        "AmazonProvidedDNS"
    ]

    tags = {
        Name = format(
            "dhcp-%s",
            lower(var.environment_name)
        )
        Environment = lower(var.environment_name)
    }
}

resource "aws_vpc_dhcp_options_association" "vpc_dhcp_main" {
    depends_on = [
        aws_vpc.main_vpc,
        aws_vpc_dhcp_options.dhcp_main
    ]
    dhcp_options_id = aws_vpc_dhcp_options.dhcp_main.id
    vpc_id = aws_vpc.main_vpc.id
}

### RT

resource "aws_route_table" "rtb_public_edge" {
    depends_on = [
        aws_vpc.main_vpc
    ]
    lifecycle {
        create_before_destroy = true
    }

    tags = {
        Name = format(
            "rtb-edge-%s-pub",
            lower(var.environment_name)
        )
        Environment = lower(var.environment_name)
    }
    vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.rtb_public_edge.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}


resource "aws_route_table_association" "main_public_association" {
    depends_on = [
        aws_route_table.rtb_public_edge,
        aws_subnet.main_subnet
    ]
    route_table_id = aws_route_table.rtb_public_edge.id
    subnet_id = aws_subnet.main_subnet.id
}

### Security Groups

resource "aws_security_group" "main_sgrp" {
    description = "Main Security Group"
    lifecycle {
        create_before_destroy = true
    }
    name = format(
        "sgrp-%s",
        lower(var.environment_name)
    )
    revoke_rules_on_delete = true

    tags = {
        Name = format(
            "sgrp-%s",
            lower(var.environment_name)
        )
        Environment = lower(var.environment_name)
    }
    vpc_id = aws_vpc.main_vpc.id
}



