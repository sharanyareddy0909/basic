variable "environment_type" {
}

variable "max_subnets" {
  default     = "8"
  description = "Maximum number of subnets that can be created. The variable is used for CIDR blocks calculation"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "vpc_cidr_block" {
  type        = "string"
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "igw_id" {
  type        = "string"
  description = "Internet Gateway ID that is used as a default route when creating public subnets (e.g. `igw-9c26a123`)"
  default     = ""
}

variable "public_network_acl_id" {
  type        = "string"
  description = "Network ACL ID that is added to the public subnets. If empty, a new ACL will be created"
  default     = ""
}

variable "public_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      icmp_type  = 0
      icmp_code  = 0
      ipv6_cidr_block = ""
    }
  ]
}

variable "public_network_acl_ingress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      icmp_type  = 0
      icmp_code  = 0
      ipv6_cidr_block = ""
    }
  ]
}

variable "nat_gateway_enabled" {
  description = "Flag to enable/disable NAT Gateways creation in public subnets"
  default     = "true"
}