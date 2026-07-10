
### SPOKE VPC
module "spoke_vpc" {
  source          = "github.com/nicknameyu/terraform-modules/modules/aws/aws_vpc"
  name            = var.spoke_vpc.name
  cidr_block      = var.spoke_vpc.cidr
  region          = var.region
  private_subnets = var.spoke_private_subnets
  tags            = var.tags
}

### HUB VPC
module "hub_vpc" {
  source               = "github.com/nicknameyu/terraform-modules/modules/aws/aws_vpc"
  name                 = var.hub_vpc.name
  cidr_block           = var.hub_vpc.cidr
  region               = var.region
  public_subnets       = var.public_subnets
  private_subnets      = var.hub_private_subnets
  firewall_subnet_cidr = var.firewall_subnet_cidr
  nat_subnet_cidr      = var.nat_subnet_cidr
  tags                 = var.tags
}

output "hub_public_subnets" {
  value = module.hub_vpc.public_subnets
}
output "hub_private_subnets" {
  value = module.hub_vpc.private_subnets
}
output "spoke_private_subnets" {
  value = module.spoke_vpc.private_subnets
}
output "hub_vpc_id" {
  value = module.hub_vpc.vpc_id
}
output "spoke_vpc_id" {
  value = module.spoke_vpc.vpc_id
}