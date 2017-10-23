provider "aws" {
  region     = "eu-west-1"
}


resource "aws_vpc" "terraform" {
  cidr_block       = "172.23.0.0/16"
  instance_tenancy = "dedicated"

  tags {
    Name = "terraform_vpc"
  }
}
// ------------------------------------------------------
// ------------------------------------------------------


resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.terraform.id}"
}

// ------------------------------------------------------
// ------------------------------------------------------



resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.terraform.id}"

  tags {
    Name = "public_aziz_rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id            =  "${aws_route_table.public_route_table.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "rt_association_1" {
  subnet_id      = "${aws_subnet.public_subnet_1.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "rt_association_2" {
  subnet_id      = "${aws_subnet.public_subnet_2.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}



// ------------------------------------------------------
// ------------------------------------------------------

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = "${aws_vpc.terraform.id}"
  cidr_block = "172.23.1.0/24"

  tags {
    Name = "public_subnet_1"
  }
}


resource "aws_subnet" "public_subnet_2" {
  vpc_id     = "${aws_vpc.terraform.id}"
  cidr_block = "172.23.2.0/24"

  tags {
    Name = "public_subnet_2"
  }
}
