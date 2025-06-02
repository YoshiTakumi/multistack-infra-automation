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
variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "my_ip" {
    type      = string
    description = "current IP"
}
variable "alb_port" {
  type = string
}

variable "vote_app_port" {
  type = string
}

variable "result_app_port" {
  type = string
}

variable "redis_port" {
  type = string
}
variable "postgres_port" {
  type = string
}
variable "ssh_port" {
  type = string
}