# Declare AZ data source 
data "aws_availability_zones" "available" {
  state = "available"
}

# create vpc 
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

# create 3 public subnets
resource "aws_subnet" "public_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnet : subnet.id]
}

# create 3 private subnets
resource "aws_subnet" "private_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet"
  }
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnet : subnet.id]
}

# create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}
/*
# create elastic ip for nat gw
resource "aws_eip" "nat_gw_eip" {
  vpc      = true
  #depends_on = [aws_nat_gateway.nat_gw]
}

# create nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
}
*/
# create public subnet route table
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public RT"
  }
}
/*
# create private subnet route table
resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private RT"
  }
}
*/
# associate public subnet RT
resource "aws_route_table_association" "public_subnet_rt_assoc" {
  count          = 3
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnet_route_table.id
}
/*
# associate private subnet RT
resource "aws_route_table_association" "private_subnet_rt_assoc" {
  count = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_subnet_route_table.id
}
*/

