provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/security-groups"

  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/loadbalancer"

  lb_sg_id             = module.sg.out_alb_sg_id
  lb_public_subnet_ids = module.vpc.public_subnet_ids
  vpc_id               = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"

  tomcat_server_sg = module.sg.out_tomcat_server_sg_id
  asg_subnet_ids   = module.vpc.private_subnet_ids
  alb_tg_arn       = module.alb.out_target_group_arn

}

