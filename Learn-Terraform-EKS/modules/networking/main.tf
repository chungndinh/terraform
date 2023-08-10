## VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project}-${var.env}-VPC"
    Enviroment = var.env
    Project = var.project
  }
}

##
data "aws_availability_zones" "availability_zones" {
  
}
## Subnet
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}", 8, 1)
  availability_zone = data.aws_availability_zones.availability_zones.names[0]

  tags = {
    Name = "${var.project}-${var.env}-Subnet-Private-1A"
    Enviroment = var.env
    Project = var.project    
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}", 8, 2)
  availability_zone = data.aws_availability_zones.availability_zones.names[1]

  tags = {
    Name = "${var.project}-${var.env}-Subnet-Private-1B"
    Enviroment = var.env
    Project = var.project    
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet("${var.vpc_cidr}", 8, 3)
  availability_zone = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.env}-Subnet-Public-1A"
    Enviroment = var.env 
    Project = var.project       
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet("${var.vpc_cidr}", 8, 4)
  availability_zone = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.env}-Subnet-Public-1B"
    Enviroment = var.env 
    Project = var.project         
  }
}

resource "aws_eip" "main" {
  vpc = true

  tags = {
    Name = "${var.project}-${var.env}-EIP"
    Enviroment = var.env 
    Project = var.project         
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "${var.project}-${var.env}-NAT"
    Enviroment = var.env   
    Project = var.project         
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-IGW"
    Enviroment = var.env  
    Project = var.project         
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project}-${var.env}-RT-Private"
    Enviroment = var.env     
    Project = var.project      
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project}-${var.env}-RT-Public"
    Enviroment = var.env   
    Project = var.project        
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "subnet_public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "subnet_public_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public.id
}
