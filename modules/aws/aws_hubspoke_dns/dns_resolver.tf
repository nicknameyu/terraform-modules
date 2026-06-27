
################ DNS private resolver for CDP VPC ############

data "aws_vpc" "spoke_vpc" {
  id = var.spoke_vpc_id
}
data "aws_vpc" "hub_vpc" {
  id = var.hub_vpc_id
}
data "aws_subnets" "spoke" {
  filter {
    name   = "vpc-id"
    values = [var.spoke_vpc_id]
  }
}

resource "aws_security_group" "dns_resolver" {
  name   = "${data.aws_vpc.spoke_vpc.tags.Name}-dns_resover-sg"
  vpc_id = var.spoke_vpc_id

  ingress {
    description      = "DNS"
    from_port        = 53
    to_port          = 53
    protocol         = "UDP"
    cidr_blocks      = [data.aws_vpc.hub_vpc.cidr_block, data.aws_vpc.spoke_vpc.cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags   = var.tags
}

resource "aws_route53_resolver_endpoint" "dns_resolver" {
  name      = "${data.aws_vpc.spoke_vpc.tags.Name}-dns_resolver-ep"
  direction = "INBOUND"

  security_group_ids = [
    aws_security_group.dns_resolver.id,
  ]

  dynamic "ip_address" {
    for_each = data.aws_subnets.spoke.ids

    content {
      subnet_id = ip_address.value
    }
  }
  protocols = ["Do53", "DoH"]

  tags = var.tags
}

output "cdp_dns_resolver_endpoint" {
  value = aws_route53_resolver_endpoint.dns_resolver.ip_address[*].ip
}