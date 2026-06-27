variable "tags" {
  type = map(string)
  default = {}
}
variable "region" {
  type = string
  default = "us-west-2"
  description = "Region of the VPCs."
}

########## VPC configurations ############
variable "hub_vpc" {
  type = object({
    name = string
    cidr = string
  })
  description = "HUB VPC name and CIDR block."
}
variable "spoke_vpc" {
  type = object({
    name = string
    cidr = string
  })
  description = "SPOKE VPC name and CIDR block."
}
variable "firewall_subnet_cidr" {
  type = string
  default = ""
  description = "Firewall subnet configuration. This version support one firewall subnet only. The subnet is in HUB VPC."
}
variable "nat_subnet_cidr" {
  type = string
  default = ""
  description = "Firewall subnet configuration. This version support one NAT subnet only. The subnet is in HUB VPC."
}
variable "public_subnets" {
  type = map(object({
    cidr  = string
    az_sn = number
  }))
  default = {}
  description = "The public subnet configurations. Public subnets are in HUB VPC only. "
}
variable "hub_private_subnets" {
  type = map(object({
    cidr  = string
    az_sn = number
  }))
  default = {}
  description = "The private subnet configurations for HUB VPC."
}
variable "spoke_private_subnets" {
  type = map(object({
    cidr  = string
    az_sn = number
  }))
  default = {}
  description = "The private subnet configurations for HUB VPC."
}

########## Transit Gateway Configuration ###########
variable "tgw_name" {
  type = string
  description = "Transit gateway name."
}
########## Egress module variables ##########
variable "igw_name" {
  type = string
  default = ""
  description = "Name of Internet Gateway for HUB VPC."
}
variable "firewall_name" {
  type = string
  default = ""
  description = "Name of Firewall for HUB VPC."
}
variable "nat_name" {
  type = string
  default = ""
  description = "Name of NAT Gateway for HUB VPC."
}

########### Custom DNS configuration ###########
variable "custom_dns" {
  type = bool
  default = true
  description = "A flag about whether to create custom DNS configuration rather than using the AWS default DNS."
}
variable "dns_server_name" {
  type = string
  default = "dns-server"
}
variable "ssh_key_name" {
  type = string
  description = "The SSH Key name to be used for creating a jump server or DNS server."
}
variable "ssh_public_key" {
  type = string
  default = ""
  description = "The SSH Public Key to be used for creating a jump server or DNS server. When provided, an AWS key pair will be created with the name `ssh_key_name`. If not provided, an AWS key pair with the name `ssh_key_name` must exist."
}
variable "ssh_private_key" {
  type = string
  default = ""
  description = "The SSH Private Key to be populated into the `/home/ubuntu/.ssh/id_rsa` file of the jume server or dns server."
}