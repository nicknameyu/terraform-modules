variable "region" {
  type = string
  default = "us-west-2"
}
variable "tags" {
  description = "Tags to be applied to the resources."
  type = map(string)
  default = null
}
variable "name" {
  type = string
  description = "Name tag for the VPC"
}
variable "cidr_block" {
  type = string
  description = "CIDR block for the VPC."
}
variable "public_subnets" {
  type = map(object({
    cidr  = string
    az_sn = number
  }))
  default = {}
  description = "Public subnet names and CIDR blocks."
}
variable "private_subnets" {
  type = map(object({
    cidr  = string
    az_sn = number
  }))
  default = {}
  description = "Private subnet names and CIDR blocks."
}
variable "firewall_subnet_cidr" {
  type = string
  default = ""
  description = "CIDR block for firewall subnet. When empty, firewall subnet is not created."
}
variable "nat_subnet_cidr" {
  type = string
  default = ""
  description = "CIDR block for NAT subnet. When empty, NAT subnet is not created."
}