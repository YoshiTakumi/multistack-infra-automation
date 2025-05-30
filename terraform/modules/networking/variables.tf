variable "aws_region" {
    description = "AWS region is use"
    type = string
}

variable "avail_zone1" {
    description = "AWS avail zone 1"
    type = string
}

variable "avail_zone2" {
    description = "AWS avail zone 2"
    type = string
}

variable "main_vpc_cidr" {
    type = string
}

variable "public_sub1_cidr" {
    type = string
}

variable "public_sub2_cidr" {
    type = string
}

variable "private_sub_vote_cidr" {
    type = string
}

variable "private_sub_result_cidr" {
    type = string
}

variable "private_sub_worker_cidr" {
    type = string
}

variable "private_sub_db_cidr"{
    type = string
}