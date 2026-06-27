resource "aws_ec2_transit_gateway" "tgw" {
  dns_support = "disable"
  tags = merge({Name = var.tgw_name}, var.tags)
}

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  subnet_ids         = [for subnet, property in module.hub_vpc.private_subnets : property.subnet_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = module.hub_vpc.vpc_id
  dns_support        = "disable"
  tags = merge({
    Name = "tgwa-hub-vpc"
  }, var.tags)
}
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  subnet_ids         = [for subnet, property in module.spoke_vpc.private_subnets : property.subnet_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = module.spoke_vpc.vpc_id
  dns_support        = "disable"
  tags = merge({
    Name = "tgwa-spoke-vpc"
  }, var.tags)
}

####### Route from SPOKE VPC to HUB VPC #######
resource "aws_route" "spoke-hub" {
  for_each                  = module.spoke_vpc.private_subnets
  route_table_id            = each.value.route_table_id
  destination_cidr_block    = var.hub_vpc.cidr
  transit_gateway_id        = aws_ec2_transit_gateway.tgw.id
}
####### Route from SPOKE VPC to HUB VPC #######
resource "aws_route" "hub-spoke" {
  for_each                  = merge({firewall_subnet = module.hub_vpc.firewall_subnet}, {nat_subnet = module.hub_vpc.nat_subnet}, module.hub_vpc.public_subnets, module.hub_vpc.private_subnets)
  route_table_id            = each.value.route_table_id
  destination_cidr_block    = var.spoke_vpc.cidr
  transit_gateway_id        = aws_ec2_transit_gateway.tgw.id
}
####### Route from SPOKE VPC to Internet #######
resource "aws_route" "spoke-internet" {
  for_each                  = module.spoke_vpc.private_subnets
  route_table_id            = each.value.route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id        = aws_ec2_transit_gateway.tgw.id
}
resource "aws_ec2_transit_gateway_route" "tgw-internet" {
  transit_gateway_route_table_id   = aws_ec2_transit_gateway.tgw.association_default_route_table_id
  destination_cidr_block           = "0.0.0.0/0"
  transit_gateway_attachment_id    = aws_ec2_transit_gateway_vpc_attachment.hub.id
}
