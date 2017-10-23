// ------------------------------------------------------
// Providers
// ------------------------------------------------------
provider "aws" {
  region     = "eu-west-1"
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
  cidr_block       = "172.23.0.0/16"


  tags {
    Name = "terraform_vpc"
  }
}
//=====

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = "${aws_vpc.terraform.id}"
  cidr_block = "172.23.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"


  tags {
    Name = "public_subnet_1"
  }
}
//=====


resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = "${aws_vpc.terraform.id}"
  cidr_block              = "172.23.2.0/24"
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
  route_table_id            =  "${aws_route_table.public_route_table.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
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

// ------------------------------------------------------
// EC2 Instances
// ------------------------------------------------------

resource "aws_instance" "web" {
  ami           = "ami-acd005d5"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public_subnet_1.id}"

  tags {
    Name = "HelloWorld Terraform"
  }
}
