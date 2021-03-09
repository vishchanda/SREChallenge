#Create VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block           = "${var.vpc_cidrblock}"
  enable_dns_hostnames = "true"

  tags = {
    Name = "demo-vpc"
  }
}

#Create private subnets
resource "aws_subnet" "demo_priv_subnet" {
  vpc_id            = "${aws_vpc.demo_vpc.id}"
  count             = "${length(var.azs)}"
  cidr_block        = "${element(var.demo_priv_subnets, count.index)}"
  availability_zone = "${element(var.azs , count.index)}"

  tags = {
    Name = "demo-priv-subnet-${count.index+1}"
  }
}

#Create public subnets
resource "aws_subnet" "demo_pub_subnet" {
  vpc_id                  = "${aws_vpc.demo_vpc.id}"
  count                   = "${length(var.azs)}"
  cidr_block              = "${element(var.demo_pub_subnets, count.index)}"
  availability_zone       = "${element(var.azs , count.index)}"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "demo-pub-subnet-${count.index+1}"
  }
}

#Create Internet Gatway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = "${aws_vpc.demo_vpc.id}"

  tags = {
    Name = "demo-igw"
  }
}

#Route table for public subnet
resource "aws_route_table" "demo_pub_rtable" {
  vpc_id = "${aws_vpc.demo_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo_igw.id}"
  }

  tags = {
    Name = "demo-pub-subnet"
  }
}

#Public Route table association
resource "aws_route_table_association" "demo_pub_rta" {
  count = "${length(var.azs)}"

  subnet_id      = "${element(aws_subnet.demo_pub_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.demo_pub_rtable.id}"
}

#EIP
resource "aws_eip" "demo_nat_eip" {
  count = "${length(var.azs)}"

  vpc = "true"

  tags = {
    Name = "demo-eip${count.index+1}"
  }
}

#NAT Gateways
resource "aws_nat_gateway" "demo_nat_gtw" {
  count         = "${length(var.azs)}"
  allocation_id = "${element(aws_eip.demo_nat_eip.*.id, count.index)}"

  subnet_id = "${element(aws_subnet.demo_pub_subnet.*.id, count.index)}"

  tags = {
    Name = "demo-nat-gtw-${count.index+1}"
  }
}

#private route tables
resource "aws_route_table" "demo_priv_rtable" {
  count  = "${length(var.azs)}"
  vpc_id = "${aws_vpc.demo_vpc.id}"

  tags = {
    Name = "demo-priv-subnet-${count.index+1}"
  }
}

#routes to private route table
resource "aws_route" "demo_priv_rtable" {
  count                  = "${length(var.azs)}"
  route_table_id         = "${element(aws_route_table.demo_priv_rtable.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.demo_nat_gtw.*.id, count.index)}"
}

#RTA for private subnets
resource "aws_route_table_association" "demo_priv_rta" {
  count = "${length(var.azs)}"

  subnet_id      = "${element(aws_subnet.demo_priv_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.demo_priv_rtable.*.id, count.index)}"
}
