variable "tags" {
  type = map(string)
  default = {}
}
variable "vpc_id" {
  type = string
  description = "VPC ID for the VPC where the egress resources to be created."
}
### IGW Variables 
variable "igw_name" {
  type = string
  description = "Name for internet gateway."
}

### Firewall Variables
variable "firewall_name" {
  type = string
  default = ""
  description = "Name of the firewall. "
}
variable "firewall_subnet" {
  type    = object({
    subnet_id      = string
    route_table_id = string
    cidr_block     = string
  })
  default = null
  # Firewall subnet is not always required.
  description = "Firewall subnet info."
}
variable "fw_ip_set" {
  type = list(string)
  default = []
  description = "The source IP CIDR blocks for firewall."
}

variable "custom_fw_https_endpoints" {
  type = list(string)
  default = []
  description = "Additional https internet endpoints for firewall."
}
variable "custom_fw_http_endpoints" {
  type = list(string)
  default = []
  description = "Additional http internet endpoints for firewall."
}

### NAT Variables
variable "nat_name" {
  type = string
  default = ""
  description = "Name of the NAT Gateway."
}
variable "nat_subnet" {
  type    = object({
    subnet_id      = string
    route_table_id = string
    cidr_block     = string
  })
  default = null
  # NAT subnet is not always required. In cases with public subnets only, no NAT gateway is required. 
  description = "NAT subnet info."
}

### Route Variables
variable "pvt_subnets" {
  type = map(object({
    subnet_id      = string
    route_table_id = string
    cidr_block     = string
  }))
  default = {}
  description = "Map of private subnets their id and route tables."
}
variable "pub_subnets" {
  type = map(object({
    subnet_id      = string
    route_table_id = string
    cidr_block     = string
  }))
  default = {}
  description = "Map of public subnets their id and route tables."
}
