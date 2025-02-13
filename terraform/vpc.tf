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
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "messaging_app-backend-subnet"
  }
}

resource "aws_subnet" "messaging_app-DB-sn" {
  vpc_id     = aws_vpc.messaging_app-vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "messaging_app-database-subnet"
  }
}

resource "aws_internet_gateway" "messaging_app-igw" {
  vpc_id = aws_vpc.messaging_app-vpc.id

  tags = {
    Name = "messaging_app-gw"
  }
}

resource "aws_route_table" "messaging_app-public-rt" {
  vpc_id = aws_vpc.messaging_app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.messaging_app-igw.id
  }

  tags = {
    Name = "messaging_app-public-rt"
  }
}

resource "aws_route_table_association" "messaging_app-frontend-asc" {
  subnet_id      = aws_subnet.messaging_app-frontend-sn.id
  route_table_id = aws_route_table.messaging_app-public-rt.id
}

resource "aws_route_table_association" "messaging_app-backend-asc" {
  subnet_id      = aws_subnet.messaging_app-backend-sn.id
  route_table_id = aws_route_table.messaging_app-public-rt.id
}

resource "aws_route_table" "messaging_app-private-rt" {
  vpc_id = aws_vpc.messaging_app-vpc.id

  tags = {
    Name = "messaging_app-private-rt"
  }
}

resource "aws_route_table_association" "messaging_app-DB-asc" {
  subnet_id      = aws_subnet.messaging_app-DB-sn.id
  route_table_id = aws_route_table.messaging_app-private-rt.id
}

resource "aws_network_acl" "messaging_app-NACL" {
  vpc_id = aws_vpc.messaging_app-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "messaging_app-NACL"
  }
}

resource "aws_network_acl_association" "messaging_app-Nacl-BE-asc" {
  network_acl_id = aws_network_acl.messaging_app-NACL.id
  subnet_id      = aws_subnet.messaging_app-backend-sn.id
}

resource "aws_network_acl_association" "messaging_app-Nacl-FE-asc" {
  network_acl_id = aws_network_acl.messaging_app-NACL.id
  subnet_id      = aws_subnet.messaging_app-frontend-sn.id
}

resource "aws_network_acl_association" "messaging_app-Nacl-DB-asc" {
  network_acl_id = aws_network_acl.messaging_app-NACL.id
  subnet_id      = aws_subnet.messaging_app-DB-sn.id
}

resource "aws_security_group" "messaging_app-FE-SG" {
  name        = "messaging_app-FE-SG"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.messaging_app-vpc.id

  tags = {
    Name = "messaging_app-FE-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "messaging_app-FE-SG-ssh" {
  security_group_id = aws_security_group.messaging_app-FE-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "messaging_app-FE-SG-http" {
  security_group_id = aws_security_group.messaging_app-FE-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_security_group" "messaging_app-BE-SG" {
  name        = "messaging_app-BE-SG"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.messaging_app-vpc.id

  tags = {
    Name = "messaging_app-BE-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "messaging_app-BE-SG-ssh" {
  security_group_id = aws_security_group.messaging_app-BE-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "messaging_app-BE-SG-http" {
  security_group_id = aws_security_group.messaging_app-BE-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_security_group" "messaging_app-DB-SG" {
  name        = "messaging_app-DB-SG"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.messaging_app-vpc.id

  tags = {
    Name = "messaging_app-DB-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "messaging_app-DB-SG-ssh" {
  security_group_id = aws_security_group.messaging_app-DB-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "messaging_app-DB-SG-http" {
  security_group_id = aws_security_group.messaging_app-DB-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}