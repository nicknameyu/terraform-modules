################# DNS config for CDP VPC ###############
data "aws_region" "current" {}

resource "aws_vpc_dhcp_options" "spoke" {
  count                = var.custom_dns ? 0:1
  domain_name          = "${data.aws_region.current.name}.compute.internal"
  domain_name_servers  = var.custom_dns ? [module.dns-server.private_ip] : ["AmazonProvidedDNS"]

  tags = merge({
    Name = "${data.aws_vpc.spoke_vpc.tags.Name}-dopt"
  }, var.tags)
}
resource "aws_vpc_dhcp_options_association" "spoke" {
  count           = var.custom_dns ? 0:1
  vpc_id          = var.spoke_vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.spoke[0].id
}

################# DNS config for HUB VPC ###############
# Do not include custom DNS in HUB VPC  
# resource "aws_vpc_dhcp_options" "hub" {
#   domain_name          = "${data.aws_vpc.hub_vpc.region}.compute.internal"
#   domain_name_servers  = ["AmazonProvidedDNS"]

#   tags = merge({
#     Name = "${data.aws_vpc.hub_vpc.tags.Name}-dopt"
#   }, var.tags)
# }
# resource "aws_vpc_dhcp_options_association" "hub" {
#   vpc_id          = var.hub_vpc.id
#   dhcp_options_id = aws_vpc_dhcp_options.hub.id
# }
