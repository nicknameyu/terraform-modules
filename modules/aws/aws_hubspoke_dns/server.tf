resource "aws_key_pair" "ssh" {
  count      = var.ssh_public_key == "" ? 0:1
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
  tags       = var.tags
}

locals {

  ssh_key_name = var.ssh_public_key == "" ? var.ssh_key_name : aws_key_pair.ssh[0].key_name # This is to create dependency.
  # dns_ingress_rules = {for k,v in var.dns_ingress_cidr :
  #                       k => {
  #                         from_port        = 53
  #                         to_port          = 53
  #                         ip_protocol      = "UDP"
  #                         cidr_block       = v
  #                       }
  # }
  dns_server_ingress_rules =  {
                                ssh =  {
                                  from_port        = 22
                                  to_port          = 22
                                  ip_protocol      = "TCP"
                                  cidr_block       = "0.0.0.0/0"
                                }
                                hub = {
                                  from_port        = 53
                                  to_port          = 53
                                  ip_protocol      = "UDP"
                                  cidr_block       = data.aws_vpc.hub_vpc.cidr_block
                                }
                                spoke = {
                                  from_port        = 53
                                  to_port          = 53
                                  ip_protocol      = "UDP"
                                  cidr_block       = data.aws_vpc.spoke_vpc.cidr_block
                                }
                              }

                            
  dns_server_egress_rules = {
                              internet = {
                                from_port        = -1
                                to_port          = -1
                                ip_protocol      = "-1"
                                cidr_block       = "0.0.0.0/0"
                              }
                            }
}
## Hub Jump Server
module "dns-server" {
  source                  = "github.com/nicknameyu/terraform-modules/modules/aws/aws_ubuntu_instance"
  name                    = var.dns_server_name
  vpc_id                  = var.hub_vpc_id
  subnet_id               = var.dns_server_subnet_id
  enable_pub_ip           = true
  key_name                = local.ssh_key_name
  bootstrap_scripts       = [ 
                              file("${path.module}/scripts/install_aws_cli.sh"), 
                              file("${path.module}/scripts/install_kubectl.sh"),
                              templatefile("${path.module}/scripts/install_bind9.sh", {
                                DNS_RESOLVER_IP = tolist(aws_route53_resolver_endpoint.dns_resolver.ip_address)[0].ip
                                REGION          = data.aws_region.current.name
                              }) 
                            ]

  sg_ingress_rules        = local.dns_server_ingress_rules
  sg_egress_rules         = local.dns_server_egress_rules

  private_key             = var.ssh_private_key

  tags                    = var.tags
}

output "dns_server_public_ip" {
  value = module.dns-server.public_ip
}
output "dns_server_private_ip" {
  value = module.dns-server.private_ip
}