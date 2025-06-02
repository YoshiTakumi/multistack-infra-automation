resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Public HTTP entry for the Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.alb_port
    to_port     = var.alb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion_sg" {
    name        = "bastion-sg"
    description = "sg for bastion ec2"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = var.ssh_port
        to_port         = var.ssh_port
        protocol        = "tcp"
        cidr_blocks     = [var.my_ip]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "vote_app_sg" {
    name        = "vote-app-sg"
    description = "sg for vote app instance"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = var.vote_app_port
        to_port         = var.vote_app_port
        protocol        = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }
    ingress {
        from_port       = var.ssh_port
        to_port         = var.ssh_port
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "result_app_sg" {
    name        = "result-app-sg"
    description = "sg for result app instance"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = var.result_app_port
        to_port         = var.result_app_port
        protocol        = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }
    ingress {
        from_port       = var.ssh_port
        to_port         = var.ssh_port
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "worker_app_sg" {
    name        = "worker-app-sg"
    description = "sg for worker app instance"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = var.ssh_port
        to_port         = var.ssh_port
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "redis_sg" {
    name        = "redis-sg"
    description = "sg for redis"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = var.redis_port
        to_port         = var.redis_port
        protocol        = "tcp"
        security_groups = [
            aws_security_group.vote_app_sg.id, aws_security_group.worker_app_sg.id
        ]
    }

    ingress {
        from_port       = var.ssh_port
        to_port         = var.ssh_port
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "postgres_sg" {
    name        = "postgres-sg"
    description = "sg for postgres"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = var.postgres_port
        to_port         = var.postgres_port
        protocol        = "tcp"
        security_groups = [aws_security_group.worker_app_sg.id,aws_security_group.result_app_sg.id]
    }
    ingress {
        from_port       = var.ssh_port
        to_port         = var.ssh_port
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "bastion_ec2" {
    ami                         = var.ami_id
    instance_type               = var.instance_type
    subnet_id                   = var.public_sub1_id
    vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
    associate_public_ip_address = true
    key_name                    = var.key_name

    tags = {
        Name = "bastion-ec2-y"
    }
}

resource "aws_instance" "vote_app_ec2" {
    ami                         = var.ami_id
    instance_type               = var.instance_type
    subnet_id                   = var.private_sub_vote_id
    vpc_security_group_ids      = [aws_security_group.vote_app_sg.id]
    associate_public_ip_address = false
    key_name                    = var.key_name

    user_data = file("${path.module}/scripts/install_docker_vote.sh")

    tags = {
        Name = "vote-app-ec2"
    }
}

resource "aws_instance" "result_app_ec2" {
    ami                         = var.ami_id
    instance_type               = var.instance_type
    subnet_id                   = var.private_sub_result_id
    vpc_security_group_ids      = [aws_security_group.result_app_sg.id]
    associate_public_ip_address = false
    key_name                    = var.key_name

    user_data = file("${path.module}/scripts/install_docker_result.sh")

    tags = {
        Name = "result-app-ec2"
    }
}

resource "aws_instance" "worker_app_ec2" {
    ami                         = var.ami_id
    instance_type               = var.instance_type
    subnet_id                   = var.private_sub_worker_id
    vpc_security_group_ids      = [aws_security_group.worker_app_sg.id]
    associate_public_ip_address = false
    key_name                    = var.key_name

    user_data = file("${path.module}/scripts/install_docker_worker.sh")

    tags = {
        Name = "worker-app-ec2"
    }
}

resource "aws_instance" "redis_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_sub_worker_id
  vpc_security_group_ids      = [aws_security_group.redis_sg.id]
  associate_public_ip_address = false
  key_name                    = var.key_name

  user_data = file("${path.module}/scripts/install_docker_redis.sh")

  tags = {
    Name = "redis-ec2"
  }
}

resource "aws_instance" "postgres_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_sub_db_id
  vpc_security_group_ids      = [aws_security_group.postgres_sg.id]
  associate_public_ip_address = false
  key_name                    = var.key_name

  user_data = file("${path.module}/scripts/install_docker_postgres.sh")

  tags = {
    Name = "postgres-ec2"
  }
}