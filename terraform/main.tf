provider "aws" {
    region = var.aws_region
}

module "networking" {
    source = "./modules/networking"
    aws_region              = var.aws_region
    main_vpc_cidr           = var.main_vpc_cidr
    public_sub1_cidr        = var.public_sub1_cidr
    public_sub2_cidr        = var.public_sub2_cidr
    private_sub_vote_cidr   = var.private_sub_vote_cidr
    private_sub_result_cidr = var.private_sub_result_cidr
    private_sub_worker_cidr = var.private_sub_worker_cidr
    private_sub_db_cidr     = var.private_sub_db_cidr
    avail_zone1             = var.avail_zone1
    avail_zone2             = var.avail_zone2

}

module "compute" {
  source = "./modules/compute"
  vpc_id               = module.networking.vpc_id
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name

  private_sub_vote_id   = module.networking.private_sub_vote_id
  private_sub_result_id = module.networking.private_sub_result_id
  private_sub_worker_id = module.networking.private_sub_worker_id
  private_sub_db_id     = module.networking.private_sub_db_id
  public_sub1_id         = module.networking.public_subnet_ids[0]
  my_ip                 = var.my_ip
  result_app_port       = var.result_app_port
  vote_app_port         = var.vote_app_port
  ssh_port              = var.ssh_port
  alb_port              = var.alb_port
  redis_port            = var.redis_port
  postgres_port         = var.postgres_port

}