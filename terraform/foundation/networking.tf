# networking.tf - All networking and vpc related items

locals {
  public_cidr = [
    cidrsubnet(var.cidr_block, 8, 0),
    cidrsubnet(var.cidr_block, 8, 1),
  ]

  private_cidr = [
    cidrsubnet(var.cidr_block, 8, 2),
    cidrsubnet(var.cidr_block, 8, 3),
  ]
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }

}

resource "aws_subnet" "private" {
  count             = length(local.private_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.private_cidr[count.index]
  availability_zone = data.aws_availability_zones.current.names[count.index]

  tags = {
    Name        = "${var.environment}-private-${data.aws_availability_zones.current.names[count.index]}"
    Environment = var.environment
    Tier        = "private"
  }
}

resource "aws_subnet" "public" {
  count                   = length(local.public_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.public_cidr[count.index]
  availability_zone       = data.aws_availability_zones.current.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-${data.aws_availability_zones.current.names[count.index]}"
    Environment = var.environment
    Tier        = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-route-table-public"
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "service_security_group" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.environment}-service-sg"
    Environment = var.environment
  }
}
