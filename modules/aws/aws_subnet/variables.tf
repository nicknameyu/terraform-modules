variable "subnet_name" {
  type = string
  description = "Name tag for the subnet."
}
variable "vpc_id" {
  type = string
  description = "VPC ID for this subnet."
}
variable "cidr_block" {
  type = string
  description = "CIDR block for this subnet."
}
variable "tags" {
  type = map(string)
  default = {}
}
variable "az_sn" {
  type = number
  description = "The availability zone serial number for the subnet."
}
variable "is_public" {
  type = bool
  default = false
  description = "A flag to control whether to create a public or private subnet. Default to false."
}