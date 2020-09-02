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

module "iam_roles" {
    source = "./modules/iam-roles"
}

module "ec2" {
  source = "./modules/ec2"

  tomcat_server_sg = module.sg.out_tomcat_server_sg_id
  asg_subnet_ids   = module.vpc.private_subnet_ids
  alb_tg_arn       = module.alb.out_target_group_arn
  ec2_codedeploy_profile = module.iam_roles.ec2_codedeploy_profile_name
}

module "s3" {
    source = "./modules/s3"

    ec2_codedeploy_role_arn = module.iam_roles.ec2_codedeploy_role_arn

}

module "codedeploy" {
    source = "./modules/codedeploy"

    app_name = var.app_name
    deployment_group_name = var.deployment_group_name
    codedeploy_service_role_arn = module.iam_roles.codedeploy_service_role_arn
    
}

