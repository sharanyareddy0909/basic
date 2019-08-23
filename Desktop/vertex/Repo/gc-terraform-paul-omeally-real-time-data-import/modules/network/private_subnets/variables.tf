
variable "environment_type" {
}

variable "max_subnets" {
  default     = "8"
  description = "Maximum number of subnets that can be created. The variable is used for CIDR blocks calculation"
}

# The code resides explicitly in a folder called private_subnet,
# therefore, there is no need to further indicate that it is a private subnet.
# variable "type" {
#   type        = "string"
#   default     = "private"
#   description = "Type of subnets to create (`private` or `public`)"
# }

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "vpc_cidr_block" {
  type        = "string"
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

# Not used anywhere, and as per description is for public, not private, subnets.
# variable "igw_id" {
#   type        = "string"
#   description = "Internet Gateway ID that is used as a default route when creating public subnets (e.g. `igw-9c26a123`)"
#   default     = ""
# }

variable "az_ngw_ids" {
  type        = "map"
  description = "Only for private subnets. Map of AZ names to NAT Gateway IDs that are used as default routes when creating private subnets"
  default     = {}
}

# Not used anywhere, and as per description is for public, not private, subnets.
# variable "public_network_acl_id" {
#   type        = "string"
#   description = "Network ACL ID that is added to the public subnets. If empty, a new ACL will be created"
#   default     = ""
# }

variable "private_network_acl_id" {
  type        = "string"
  description = "Network ACL ID that is added to the private subnets. If empty, a new ACL will be created"
  default     = ""
}

variable "private_network_acl_egress" {
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

variable "private_network_acl_ingress" {
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

variable "az_ngw_count" {
  description = "Count of items in the `az_ngw_ids` map. Needs to be explicitly provided since Terraform currently can't use dynamic count on computed resources from different modules. https://github.com/hashicorp/terraform/issues/10857"
  default     = 0
}
