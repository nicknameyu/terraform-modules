variable "tags" {
  type = map(string)
  default = {}
}
## HUB-SPOKE VPC Info
variable "spoke_vpc_id" {
  type = string
  description = "VPC ID for the VPC where the DNS resolver to be created. Usually this should be the SPOKE VPC"
}
variable "hub_vpc_id" {
  type = string
  description = "VPC ID for the VPC where the DNS server to be created. Usually this should be the HUB VPC"
}

variable "custom_dns" {
  type = bool
  default = true
  description = "A flag about whether to create custom DNS configuration rather than using the AWS default DNS."
}
### DNS server variables
variable "dns_server_name" {
  type = string
  default = "dns-server"
  description = "The name of the DNS server."
}
variable "dns_server_subnet_id" {
  type = string
  description = "The subnet ID to create the DNS server."
}

variable "ssh_public_key" {
  type = string
  default = ""
  description = "SSH Public Key. When provided, an AWS key pair will be created."
}
variable "ssh_key_name" {
  type = string
  description = "SSH Key Pair name. When SSH Public Key is provided, the Key Pair will be created."
}
variable "ssh_private_key" {
  type = string
  default = ""
  description = "SSH Private key to be passed to the `/home/ubuntu/.ssh/id_rsa` file."
}
