module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  az_1                  = var.az_1
  az_2                  = var.az_2
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source = "./modules/ecs"
  subnets = [
    module.vpc.private_subnet_1_id,
    module.vpc.private_subnet_2_id
  ]
  alb_tg_arn = module.alb.alb_tg_arn
  ecs_sg_id  = module.sg.ecs_sg_id
  img_uri    = module.ecr.image_uri_main
}

module "alb" {
  source = "./modules/alb"
  subnets = [
    module.vpc.public_subnet_1_id,
    module.vpc.public_subnet_2_id
  ]
  alb_sg_id = module.sg.alb_sg_id
  vpc_id    = module.vpc.vpc_id
  cert_arn  = module.acm.cert_arn
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "acm" {
  source         = "./modules/acm"
  subdomain_name = var.subdomain_name
  zone_name      = var.zone_name
}

module "route53" {
  source         = "./modules/route53"
  alb_dns_name   = module.alb.alb_dns_name
  subdomain_name = var.subdomain_name
  zone_name      = var.zone_name
  alb_zone_id    = module.alb.alb_zone_id
}