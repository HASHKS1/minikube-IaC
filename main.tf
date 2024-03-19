module "vpc-ew3" {
  source           = "./Modules/networking"
  vpc_cidr         = var.vpc_cidr
  region_name      = var.aws_default_region
  environment_name = var.environment
  vpc_subnets      = var.vpc_subnets
}


module "ec2-minikube" {
  source           = "./Modules/compute/EC2"
  application_name = "minikube"
  instance_type    = var.instance_ec2_type
  environment_name = var.environment
  vpc_id           = module.vpc-ew3.vpc_id
  subnet_ids       = module.vpc-ew3.main_app_subnet_id
}
