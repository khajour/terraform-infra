// ------------------------------------------------------
// Providers
// ------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}


// ------------------------------------------------------
// Terraform Remote State on S3
// ------------------------------------------------------

terraform {
  backend "s3" {
    bucket = "khajour-s3"
    key = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "rs-vpc" {
  backend = "s3"
  config = {
    region = "eu-west-1"
    bucket = "khajour-s3"
    key = "vpc/terraform.tfstate"
  }
}

// ------------------------------------------------------
// ------------------------------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.terraform.id}"
}



// ------------------------------------------------------
// Network
// ------------------------------------------------------

resource "aws_vpc" "terraform" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "terraform_vpc"
  }
}


//=====

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = "${aws_vpc.terraform.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags {
    Name = "public_subnet_1"
  }
}

//=====

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = "${aws_vpc.terraform.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1b"

  tags {
    Name = "public_subnet_2"
  }
}

//=====

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.terraform.id}"

  tags {
    Name = "public_aziz_rt"
  }
}

//=====

resource "aws_route" "public_route" {
  route_table_id         = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

//=====

resource "aws_route_table_association" "rt_association_1" {
  subnet_id      = "${aws_subnet.public_subnet_1.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

//=====

resource "aws_route_table_association" "rt_association_2" {
  subnet_id      = "${aws_subnet.public_subnet_2.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}
