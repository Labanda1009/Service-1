

# -----------------------
# VPC
# -----------------------
resource "aws_vpc" "ProdVPC" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ProdVPC"
  }
}

# -----------------------
# Internet Gateway
# -----------------------
resource "aws_internet_gateway" "ProdVPCIGW" {
  vpc_id = aws_vpc.ProdVPC.id

  tags = {
    Name = "ProdVPCIGW"
  }
}

# -----------------------
# Public Subnet
# -----------------------
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.ProdVPC.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "public-subnet1"
  }
}

# -----------------------
# Route Table (Public)
# -----------------------
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.ProdVPC.id

  tags = {
    Name = "public_rtb"
  }
}
# -----------------------
# Security Group (Web)
# -----------------------
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.ProdVPC.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# -----------------------
# Default Route to Internet
# -----------------------
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ProdVPCIGW.id
}

# -----------------------
# Route Table Association
# -----------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public_rtb.id
}
