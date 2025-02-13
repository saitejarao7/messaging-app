resource "aws_vpc" "messaging_app-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "messaging_app-vpc"
  }
}

resource "aws_subnet" "messaging_app-frontend-sn" {
  vpc_id     = aws_vpc.messaging_app-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "messaging_app-frontend-subnet"
  }
}

resource "aws_subnet" "messaging_app-backend-sn" {
  vpc_id     = aws_vpc.messaging_app-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "messaging_app-backend-subnet"
  }
}