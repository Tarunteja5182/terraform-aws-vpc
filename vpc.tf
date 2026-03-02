resource "aws_vpc" "mod_vpc"{
    cidr_block= var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames= "true"
    tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mod_vpc.id

  tags = {
    Name = "Roboshop-dev"
  }
}

resource "aws_subnet" "public" {
  count = len(var.public_subnet_cidr)
  vpc_id     = aws_vpc.mod_vpc.id
  availability_zone   = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.public_subnet_cidr[count.index]

  tags = {
    Name = "roboshop-dev"
  }
}

resource "aws_subnet" "private" {
  count = len(var.private_subnet_cidr)
  vpc_id     = aws_vpc.mod_vpc.id
  availability_zone   = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.private_subnet_cidr[count.index]

  tags = {
    Name = "roboshop-dev"
  }
}

resource "aws_subnet" "database" {
  count = len(var.database_subnet_cidr)
  vpc_id     = aws_vpc.mod_vpc.id
  availability_zone   = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.database_subnet_cidr[count.index]

  tags = {
    Name = "roboshop-dev"
  }
}