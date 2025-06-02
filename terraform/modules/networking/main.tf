resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "voting-nat-eip"
  }
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_sub1.id
  tags = {
    Name = "voting-nat-gw"
  }

  depends_on = [aws_internet_gateway.igw]
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "voting-private-rt"
  }
}
resource "aws_route_table_association" "private_vote" {
  subnet_id      = aws_subnet.private_sub_vote.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_result" {
  subnet_id      = aws_subnet.private_sub_result.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_worker" {
  subnet_id      = aws_subnet.private_sub_worker.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db" {
  subnet_id      = aws_subnet.private_sub_db.id
  route_table_id = aws_route_table.private.id
}
resource "aws_vpc" "main_vpc" {
    cidr_block = var.main_vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "voting-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main_vpc.id
    tags = {
        Name = "voting-igw"
    }
}

resource "aws_subnet" "public_sub1" {
    vpc_id                  = aws_vpc.main_vpc.id
    cidr_block              = var.public_sub1_cidr
    availability_zone       = var.avail_zone1
    map_public_ip_on_launch = true
    tags = {
        Name = "voting-public-sub1"
    }
}

resource "aws_subnet" "public_sub2" {
    vpc_id                  = aws_vpc.main_vpc.id
    cidr_block              = var.public_sub2_cidr
    availability_zone       = var.avail_zone2
    map_public_ip_on_launch = true
    tags = {
        Name = "voting-public-sub2"
    }
}

resource "aws_subnet" "private_sub_vote" {
    vpc_id                  = aws_vpc.main_vpc.id
    cidr_block              = var.private_sub_vote_cidr
    availability_zone       = var.avail_zone1
    tags = {
        Name = "private-vote-sub"
    }
}

resource "aws_subnet" "private_sub_result" {
    vpc_id                  = aws_vpc.main_vpc.id
    cidr_block              = var.private_sub_result_cidr
    availability_zone       = var.avail_zone1
    tags = {
        Name = "private-result-sub"
    }
}

resource "aws_subnet" "private_sub_worker" {
    vpc_id                  = aws_vpc.main_vpc.id
    cidr_block              = var.private_sub_worker_cidr
    availability_zone       = var.avail_zone1
    tags = {
        Name = "private-worker-sub"
    }
}

resource "aws_subnet" "private_sub_db"{
    vpc_id                  = aws_vpc.main_vpc.id
    cidr_block              = var.private_sub_db_cidr
    availability_zone       = var.avail_zone1
    tags = {
        Name = "private-db-sub"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "voting-public-rt"
    }
}

resource "aws_route_table_association" "public1" {
    subnet_id       = aws_subnet.public_sub1.id
    route_table_id  = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
    subnet_id       = aws_subnet.public_sub2.id
    route_table_id  = aws_route_table.public.id
}
