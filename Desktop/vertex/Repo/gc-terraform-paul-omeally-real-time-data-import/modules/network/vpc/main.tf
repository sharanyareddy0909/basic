module "vpc_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "vpc"
  resource_name = local.vpc_name
}

resource "aws_vpc" "default" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  tags                             = module.vpc_tags.tags
}

module "igw_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "internet gateway"
  resource_name = "${title(var.environment_type)} Environment Internet Gateway"
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags   = module.igw_tags.tags
}