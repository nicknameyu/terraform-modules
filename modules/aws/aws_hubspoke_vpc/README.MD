# Module: aws_hubspoke_vpc

## Design
When creating a hub-spoke VPC on AWS, the steps includes:
- Create at least two VPCs as well as subnets
- Create Transit Gateway
- Create Internet Gateway and associate it to the hub VPC
- Create NAT gateway in the HUB VPC
- Create Firewall in the HUB VPC
- Route population
- DNS configuration

### VPCs have to be created first. VPC module includes:
- VPC
- Route tables
- public and private subnets
- Associate S3 gateway endpoint

### Transit gateway include
- Transit gateway
- Transit gateway attachments
- Internet prefix route on the TGW route table and SPOKE route table.

### Egress module
Include IGW, NAT Gateway, Firewall into the same egress module, because the route population depends on each other.
