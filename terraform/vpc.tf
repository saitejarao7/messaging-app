resource "aws_vpc" "messaging_app-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "messaging_app-vpc"
  }
}