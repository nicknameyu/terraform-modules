# Create IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = merge({
    Name = var.igw_name
  }, var.tags)
}

resource "aws_route_table" "igw" {
  vpc_id = var.vpc_id

  tags = merge({
    Name = "rt_${var.igw_name}"
  }, var.tags)
}

resource "aws_route_table_association" "igw" {
  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_route_table.igw.id
}

# Associate public subnet out bound route to IGW
resource "aws_route" "pub_subnets_igw" {
  for_each                  = var.pub_subnets
  route_table_id            = each.value.route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}
