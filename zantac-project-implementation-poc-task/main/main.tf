module "vpc" {
  source     = "../modules/vpc"
  cidr_block = var.vpc_cidr
}


module "alb" {
  source           = "../modules/alb"
  subnet_ids        = module.vpc.public_subnet_ids
  vpc_id           = module.vpc.vpc_id
  instance_ids     = module.ec2.instance_ids
  sg_id         = module.vpc.alb_sg_id      
}


module "ec2" {
  source            = "../Modules/ec2"
  key_name          = var.key_name
  subnet_ids        = module.vpc.public_subnet_ids
  sg_id             = module.vpc.web_sg_id
  target_group_arns = [module.alb.target_group_arn]
  user_data_path    = var.user_data_path
}



module "iam" {
  source = "../modules/iam"
}