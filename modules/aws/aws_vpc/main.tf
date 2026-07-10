resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge({ Name = var.name}, var.tags)
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
###### NAT Subnet #####
module "nat_subnet" {
  count       = var.nat_subnet_cidr == "" ? 0:1
  source      = "github.com/nicknameyu/terraform-modules/modules/aws/aws_subnet"
  subnet_name = "${var.name}_nat_subnet"
  vpc_id      = aws_vpc.vpc.id
  cidr_block  = var.nat_subnet_cidr
  az_sn       = 0
  tags        = var.tags
}
output "nat_subnet" {
  value = var.nat_subnet_cidr == "" ? null:{
    subnet_id      = module.nat_subnet[0].subnet_id
    route_table_id = module.nat_subnet[0].route_table_id
    cidr_block     = module.nat_subnet[0].cidr_block
  }
}
##### Firewall subnet #######
module "firewall_subnet" {
  count       = var.firewall_subnet_cidr == "" ? 0:1
  source      = "github.com/nicknameyu/terraform-modules/modules/aws/_subnet"
  subnet_name = "${var.name}_firewall_subnet"
  vpc_id      = aws_vpc.vpc.id
  cidr_block  = var.firewall_subnet_cidr
  az_sn       = 0
  tags        = var.tags
}
output "firewall_subnet" {
  value = var.firewall_subnet_cidr == "" ? null:{
    subnet_id      = module.firewall_subnet[0].subnet_id
    route_table_id = module.firewall_subnet[0].route_table_id
    cidr_block     = module.firewall_subnet[0].cidr_block
  }
}
##### Public Subnets #####
module "public_subnet" {
  for_each      = var.public_subnets
  source        = "github.com/nicknameyu/terraform-modules/modules/aws/aws_subnet"
  subnet_name   = each.key
  vpc_id        = aws_vpc.vpc.id
  cidr_block    = each.value.cidr
  az_sn         = each.value.az_sn
  is_public     = true
  tags          = var.tags
}
output "public_subnets" {
  value = {
    for name, subnet in module.public_subnet : name => {
      subnet_id      = subnet.subnet_id
      route_table_id = subnet.route_table_id
      cidr_block     = subnet.cidr_block
    }
  }
}

##### Private Subnets #####
module "private_subnet" {
  for_each    = var.private_subnets
  source      = "github.com/nicknameyu/terraform-modules/modules/aws/aws_subnet"
  subnet_name = each.key
  vpc_id      = aws_vpc.vpc.id
  cidr_block  = each.value.cidr
  az_sn       = each.value.az_sn
  tags        = var.tags
}
output "private_subnets" {
  value = {
    for name, subnet in module.private_subnet : name => {
      subnet_id      = subnet.subnet_id
      route_table_id = subnet.route_table_id
      cidr_block     = subnet.cidr_block
    }
  }
}

##### S3 Gateway Endpoint #####
## NAT and Firewall subnets doesn't need s3 gateway endpoint association
resource "aws_vpc_endpoint" "s3_ep" {
  vpc_id            = aws_vpc.vpc.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.s3"

  tags              = merge({
                          Name = "${var.name}-s3-ep"
                        }, var.tags)
}

resource "aws_vpc_endpoint_route_table_association" "s3_ep" {
   for_each                   = merge({
                                        for name, subnet in module.public_subnet : name => subnet.route_table_id
                                      },
                                      {
                                        for name, subnet in module.private_subnet : name => subnet.route_table_id
                                      },
                                      )
   route_table_id             = each.value
   vpc_endpoint_id            = aws_vpc_endpoint.s3_ep.id
}
