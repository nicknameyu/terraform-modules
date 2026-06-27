module "dns" {
  source = "github.com/nicknameyu/terraform-modules/modules/aws/aws_hubspoke_dns"
  hub_vpc_id = module.hub_vpc.vpc_id
  spoke_vpc_id = module.spoke_vpc.vpc_id
  custom_dns = var.custom_dns
  dns_server_name = var.dns_server_name
  ssh_key_name = var.ssh_key_name
  ssh_public_key = var.ssh_public_key
  ssh_private_key = var.ssh_private_key
  dns_server_subnet_id = values(module.hub_vpc.public_subnets)[0].subnet_id

  tags = var.tags
}

output "dns_server_public_ip" {
  value = module.dns.dns_server_public_ip
}
output "dns_server_private_ip" {
  value = module.dns.dns_server_private_ip
}