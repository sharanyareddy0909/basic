#
# S U B N E T S
###########################################################




locals {
  type = "list"
  subnets = ["10.33.4.0/24","10.33.5.0/24"]
}

resource "aws_subnet" "public" {
  count             = local.public_count
  vpc_id            = var.vpc_id
  availability_zone = element(data.aws_availability_zones.availability_zones.names, count.index)
  cidr_block        = element(local.subnets, count.index) #cidrsubnet(var.vpc_cidr_block, ceil(log(var.max_subnets, 2)), count.index)

  tags = merge(
          module.subnet_tags.tags,
          {
            "Name" = "${title(var.environment_type)} Environment - ${element(data.aws_availability_zones.availability_zones.names, count.index)}-${title(local.subnet_type)} Subnet ${count.index + 1}",
            "AZ" = element(data.aws_availability_zones.availability_zones.names, count.index),
            "Type" = local.subnet_type,
            "CIDR_BLOCK" = cidrsubnet(var.vpc_cidr_block, ceil(log(var.max_subnets, 2)), count.index)
          }
        )

}

resource "aws_network_acl" "public" {
  count      = signum(length(var.public_network_acl_id)) == 0 ? 1 : 0
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.public.*.id
  egress     = var.public_network_acl_egress
  ingress    = var.public_network_acl_ingress

  tags = module.network_acl_tags.tags

  depends_on = ["aws_subnet.public"]
}

#
# R O U T I N G
###########################################################
resource "aws_route_table" "public" {
  count  = local.public_count
  vpc_id = var.vpc_id

  tags = merge(
          module.route_table_tags.tags,
          {
            "Name" = "${title(var.environment_type)} Environment - ${element(data.aws_availability_zones.availability_zones.names, count.index)}-${title(local.subnet_type)} Route Table ${count.index + 1}",
            "AZ" = "${element(data.aws_availability_zones.availability_zones.names, count.index)}"
          }
        )
}

resource "aws_route_table_association" "public" {
  count          = local.public_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
  depends_on     = ["aws_subnet.public", "aws_route_table.public"]
}

resource "aws_route" "public" {
  count                  = local.public_count
  route_table_id         = element(aws_route_table.public.*.id, count.index)
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.public"]
}

#
# N A T   G A T E W A Y
###########################################################

resource "aws_eip" "public" {
  count = local.public_nat_gateways_count
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "public" {
  count         = local.public_nat_gateways_count
  allocation_id = element(aws_eip.public.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = ["aws_subnet.public"]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
          module.nat_gateway_tags.tags,
          {
            "Name" = "${title(var.environment_type)} Environment - ${element(data.aws_availability_zones.availability_zones.names, count.index)}-${title(local.subnet_type)} NAT Gateway ${count.index + 1}",
            "AZ" = element(data.aws_availability_zones.availability_zones.names, count.index),
            "Type" = local.subnet_type
          }
        )
}