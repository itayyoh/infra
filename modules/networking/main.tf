# VPC config
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = merge(
        local.all_tags,
        {
            Name = "${var.environment}-vpc"
        }
    )
}

# Public subnets config
resource "aws_subnet" "public" {
    count = length(var.availability_zones)
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = merge(
        local.all_tags,
        {
            Name = "${var.environment}-public-${var.availability_zones[count.index]}"
            "kubernetes.io/role/elb" = "1"
            "kubernetes.io/cluster/${var.environment}-eks" = "shared"
        }
    )
}

resource "aws_subnet" "private" {
    count = length(var.availability_zones)
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + length(var.availability_zones))
    availability_zone = var.availability_zones[count.index]

    tags = merge(
        local.all_tags,
        {
            Name = "${var.environment}-private-${var.availability_zones[count.index]}"
            "kubernetes.io/role/internal-elb" = "1"
            "kubernetes.io/cluster/${var.environment}-eks" = "shared"
        }
    )
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        local.all_tags,
        {
            Name = "${var.environment}-igw"
        }
    )
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = merge(
        local.all_tags,
        {
            Name = "${var.environment}-public-rtb"
        }
    )
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        local.all_tags,
        {
            Name = "${var.environment}-private-rt"
        }
    )
} 

resource "aws_route_table_association" "public" {
    count = length(var.availability_zones)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = length(var.availability_zones)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}