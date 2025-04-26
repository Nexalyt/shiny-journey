resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = merge(var.tags, { Name = "legal-dd-vpc${var.environment}" })
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = merge(var.tags, { Name = "legal-dd-public-subnet-${count.index}${var.environment}" })
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + 2)
  map_public_ip_on_launch = false
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = merge(var.tags, { Name = "legal-dd-private-subnet-${count.index}${var.environment}" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, { Name = "legal-dd-igw${var.environment}" })
}

resource "aws_nat_gateway" "this" {
  count = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = merge(var.tags, { Name = "legal-dd-natgw-${count.index}${var.environment}" })
}

resource "aws_eip" "nat" {
  count = 2
  vpc = true
  tags = merge(var.tags, { Name = "legal-dd-nat-eip-${count.index}${var.environment}" })
}

data "aws_availability_zones" "available" {}

# Security groups for API, EKS nodes, Lambda (examples)
resource "aws_security_group" "api" {
  name        = "legal-dd-api-sg${var.environment}"
  description = "API Gateway SG"
  vpc_id      = aws_vpc.this.id
  tags        = var.tags
}

resource "aws_security_group" "eks_nodes" {
  name        = "legal-dd-eks-nodes-sg${var.environment}"
  description = "EKS Nodes SG"
  vpc_id      = aws_vpc.this.id
  tags        = var.tags
}

resource "aws_security_group" "lambda" {
  name        = "legal-dd-lambda-sg${var.environment}"
  description = "Lambda SG"
  vpc_id      = aws_vpc.this.id
  tags        = var.tags
}
