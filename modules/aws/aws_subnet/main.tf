data "aws_availability_zones" "az" {
  state = "available"
}
resource "aws_route_table" "default" {
  vpc_id = var.vpc_id
  tags   = merge({Name = "rt_${var.subnet_name}"}, var.tags)
}
resource "aws_subnet" "default" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = data.aws_availability_zones.az.names[var.az_sn]
  map_public_ip_on_launch = var.is_public
  tags                    = merge({Name = var.subnet_name}, var.tags)
}
resource "aws_route_table_association" "nat" {
  subnet_id      = aws_subnet.default.id
  route_table_id = aws_route_table.default.id
}
output "subnet_id" {
  value = aws_subnet.default.id
}
output "route_table_id" {
  value = aws_route_table.default.id
}
output "cidr_block" {
  value = aws_subnet.default.cidr_block
}