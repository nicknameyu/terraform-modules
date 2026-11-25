data "aws_ami" "instance" {
     most_recent = true
     filter {
        name   = "name"
        values = [var.ami_filter]
 }
     filter {
       name   = "virtualization-type"
       values = ["hvm"]
 }
     owners = [var.ami_owner]
 }

## Security group
resource "aws_security_group" "instance" {
  name   = "${var.name}-sg"
  vpc_id = var.vpc_id
  tags   = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "instance" {
  for_each          = var.sg_ingress_rules
  description       = each.key
  security_group_id = aws_security_group.instance.id
  cidr_ipv4         = each.value.cidr_block
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "instance" {
  for_each          = var.sg_egress_rules
  description       = each.key
  security_group_id = aws_security_group.instance.id
  cidr_ipv4         = each.value.cidr_block
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
}

## Network interface and IP configuration
resource "aws_network_interface" "instance" {
  subnet_id       = var.subnet_id
  security_groups = [ aws_security_group.instance.id ]

  tags            = merge({
                        Name = "${var.name}-nic"
                    }, var.tags)
}
resource "aws_eip" "instance" {
  count             = var.enable_pub_ip ? 1:0
  network_interface = aws_network_interface.instance.id
  domain            = "vpc"
  tags              = merge({
                                Name = "${var.name}-eip"
                            }, var.tags)
  depends_on = [
    aws_instance.instance
  ]
}

output "public_ip" {
  value = var.enable_pub_ip ? aws_eip.instance[0].public_ip : null
}
output "private_ip" {
  value = aws_network_interface.instance.private_ip
}

## Instance
resource "aws_instance" "instance" {
  ami           = data.aws_ami.instance.id
  instance_type = var.instance_type
  key_name      = var.key_name

  primary_network_interface {
    network_interface_id = aws_network_interface.instance.id
  }

  get_password_data = true
  credit_specification {
    cpu_credits = "unlimited"
  }
  tags = merge({
    Name = var.name
  }, var.tags)
  lifecycle {
    ignore_changes = [ ami ]
  }
}
output "connect_info" {
  value = {
            public_ip = var.enable_pub_ip ? aws_eip.instance[0].public_ip : null
            username  = "Administrator"
            password  = rsadecrypt(aws_instance.instance.password_data, var.private_key)
          }
}