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
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.mod_vpc.id
  availability_zone   = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.public_subnet_cidr[count.index]

  tags = {
    Name = "roboshop-dev-public-${data.aws_availability_zones.available[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.mod_vpc.id
  availability_zone   = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.private_subnet_cidr[count.index]

  tags = {
    Name = "roboshop-dev-private"
  }
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.mod_vpc.id
  availability_zone   = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.database_subnet_cidr[count.index]

  tags = {
    Name = "roboshop-dev-database"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.mod_vpc.id

  tags = {
    Name = "public-route"
  }
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.example.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_eip" "eip" {
  domain                    = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "Roboshop-gw-NAT"
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.example.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.example.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.ngw.id
}


resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.example.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.example.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.example.id
}