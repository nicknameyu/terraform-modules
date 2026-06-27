resource "aws_eip" "nat" {
  count = var.nat_name == "" ? 0:1
  domain   = "vpc"
  tags = merge({
    Name = "eip-nat-gw"
  }, var.tags)
}
resource "aws_nat_gateway" "nat" {
  count = var.nat_name == "" ? 0:1  
  allocation_id     = aws_eip.nat[0].id
  subnet_id         = var.nat_subnet.subnet_id
  tags              = merge({Name = var.nat_name }, var.tags)
}

## Associate private subnets with the NAT gateway.
resource "aws_route" "pvt_subnets_nat" {
  for_each                  = var.nat_name == "" ? {}:var.pvt_subnets
  route_table_id            = each.value.route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.nat[0].id
}

## Associate NAT Gateway outbound route with IGW if firewall name is not provided
resource "aws_route" "nat_igw" {
  count                     = var.firewall_name != "" ? 0 : 1
  route_table_id            = var.nat_subnet.route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}

