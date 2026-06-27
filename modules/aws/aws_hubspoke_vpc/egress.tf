module "egress" {
  count           = var.igw_name == "" ? 0:1
  source          = "github.com/nicknameyu/terraform-modules/modules/aws/aws_vpc_egress"
  igw_name        = var.igw_name
  firewall_name   = var.firewall_name
  nat_name        = var.nat_name
  vpc_id          = module.hub_vpc.vpc_id
  nat_subnet      = module.hub_vpc.nat_subnet
  firewall_subnet = module.hub_vpc.firewall_subnet
  pub_subnets     = module.hub_vpc.public_subnets
  pvt_subnets     = module.hub_vpc.private_subnets
  fw_ip_set       = [var.hub_vpc.cidr, var.spoke_vpc.cidr]
  tags            = var.tags
}

