###
### Provider
###
provider "aws" {
  profile = "Deployment-IaC"
  region  = var.aws_default_region
  alias   = "apps"
}

terraform {
  required_version = ">= 0.15.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    local = {
      source = "hashicorp/local"
      version = "~> 2.4.0"
    }

    archive = {
      source = "hashicorp/archive"
      version = "~> 2.3.0"
    }
    
  }
}
