# Create firewall
##################### Firewall ######################
## Standard rule group is for IP based communication. 
## This is for inbound access from internet to public subnets if the public subnet is subject to firewall control. 
## Currently, no actual rule defined in this group, because public subnets are not subject to firewall control in current design.
# resource "aws_networkfirewall_rule_group" "fw_standard_rg" {
#   count    = var.firewall_name == "" ? 0:1
#   capacity = 100
#   name     = "${var.firewall_name}-standard-rulegroup"
#   type     = "STATEFUL"
  
#   rule_group {
#     stateful_rule_options {
#       rule_order = "STRICT_ORDER"
#     }
#     rules_source {
#     }
#   }
#   tags = var.tags
# }
## Https rule group is for domain based firewall rules. It is outbound traffic from private subnets to internet.
resource "aws_networkfirewall_rule_group" "https" {
  count    = var.firewall_name == "" ? 0:1
  capacity = 100
  name     = "${var.firewall_name}-https-rulegroup"
  type     = "STATEFUL"
  
  rule_group {
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = var.fw_ip_set
        }
      }
    }
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types = ["TLS_SNI"]
        targets = local.fw_https_ep
      }
    }

  }
  tags = var.tags
}

resource "aws_networkfirewall_rule_group" "http" {
  count    = var.firewall_name == "" ? 0:1
  capacity = 100
  name     = "${var.firewall_name}-http-rulegroup"
  type     = "STATEFUL"
  
  rule_group {
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = var.fw_ip_set
        }
      }
    }
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types = ["HTTP_HOST"]
        targets = local.fw_http_ep
      }
    }

  }
  tags = var.tags
}

resource "aws_networkfirewall_firewall_policy" "fw" {
  count = var.firewall_name == "" ? 0:1
  name = "${var.firewall_name}-policy"


  firewall_policy {
    stateful_default_actions = ["aws:drop_established"]
    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    # stateful_rule_group_reference {
    #   priority = 1
    #   resource_arn = aws_networkfirewall_rule_group.fw_standard_rg.arn
    # }
    stateful_rule_group_reference {
      priority = 1
      resource_arn = aws_networkfirewall_rule_group.https[0].arn
    }
    stateful_rule_group_reference {
      priority = 2
      resource_arn = aws_networkfirewall_rule_group.http[0].arn
    }
  }

  tags = var.tags
}
resource "aws_networkfirewall_firewall" "fw" {
  count               = var.firewall_name == "" ? 0:1
  name                = var.firewall_name
  firewall_policy_arn = aws_networkfirewall_firewall_policy.fw[0].arn
  vpc_id              = var.vpc_id
  subnet_mapping {
    subnet_id = var.firewall_subnet.subnet_id
  }

  tags = var.tags
}

## Associate NAT Gateway outbound route with firewall if firewall name is provided.
resource "aws_route" "nat_fw" {
  count                     = var.firewall_name == "" ? 0 : 1
  route_table_id            = var.nat_subnet.route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  vpc_endpoint_id           = (tolist(aws_networkfirewall_firewall.fw[0].firewall_status[0].sync_states))[0].attachment[0].endpoint_id
}

# Associate firewall outbound route to igw
resource "aws_route" "fw-igw" {
  route_table_id            = var.firewall_subnet.route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}
# Associate NAT destination inbound route on IGW route table to firewall
data "aws_subnet" "nat_subnet" {
  count = var.nat_subnet == null ? 0:1
  id    = var.nat_subnet.subnet_id
}
data "aws_subnet" "pvt_subnets" {
  for_each = var.pvt_subnets
  id       = each.value.subnet_id
}

resource "aws_route" "igw_fw_nat" {
  count                     = var.nat_subnet == null ? 0 : 1
  route_table_id            = aws_route_table.igw.id
  destination_cidr_block    = var.nat_subnet.cidr_block
  vpc_endpoint_id           = var.firewall_name == "" ? null : (tolist(aws_networkfirewall_firewall.fw[0].firewall_status[0].sync_states))[0].attachment[0].endpoint_id
  nat_gateway_id            = var.firewall_name != "" ? null : aws_nat_gateway.nat[0].id
}
resource "aws_route" "igw_fw_pvt" {
  for_each                  = var.pvt_subnets
  route_table_id            = aws_route_table.igw.id
  destination_cidr_block    = each.value.cidr_block
  vpc_endpoint_id           = var.firewall_name == "" ? null : (tolist(aws_networkfirewall_firewall.fw[0].firewall_status[0].sync_states))[0].attachment[0].endpoint_id
  nat_gateway_id            = var.firewall_name != "" ? null : aws_nat_gateway.nat[0].id
}