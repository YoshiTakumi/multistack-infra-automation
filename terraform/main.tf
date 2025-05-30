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