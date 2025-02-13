resource "aws_vpc" "messagingapp-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "messagingapp-vpc"
  }
}