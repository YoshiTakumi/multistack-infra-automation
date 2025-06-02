variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key name for EC2 access"
  type        = string
}

variable "public_sub1_id" {
  type        = string
}

variable "public_sub2_id" {
  type = string
}

variable "private_sub_vote_id" {
  description = "Subnet ID for the vote app"
  type        = string
}

variable "private_sub_result_id" {
  description = "Subnet ID for the result app"
  type        = string
}

variable "private_sub_worker_id" {
  description = "Subnet ID for worker and Redis"
  type        = string
}

variable "private_sub_db_id" {
  description = "Subnet ID for the Postgres DB"
  type        = string
}
variable "my_ip" {
  description = "Your public IP in CIDR notation"
  type        = string
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

