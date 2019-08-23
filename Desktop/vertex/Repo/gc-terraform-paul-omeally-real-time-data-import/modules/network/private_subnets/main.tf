#
# S U B N E T S
###########################################################

locals {
  type = "list"
  subnets = ["10.33.10.0/24","10.33.11.0/24"]
}

resource "aws_subnet" "private" {
  count             = local.private_count
  vpc_id            = var.vpc_id
  availability_zone = element(data.aws_availability_zones.availability_zones.names, count.index)
  cidr_block        = element(local.subnets, count.index) #cidrsubnet(var.vpc_cidr_block, ceil(log(var.max_subnets, 2)), count.index)

  tags = merge(
          module.subnet_tags.tags,
          {
            "Name" = "${title(var.environment_type)} Environment - ${element(data.aws_availability_zones.availability_zones.names, count.index)}-${title(local.subnet_type)} Subnet ${count.index + 1}",
            "AZ" = element(data.aws_availability_zones.availability_zones.names, count.index),
            "Type" = local.subnet_type
          }
        )
}

resource "aws_network_acl" "private" {
  count      = signum(length(var.private_network_acl_id)) == 0 ? 1 : 0
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.private.*.id
  egress     = var.private_network_acl_egress
  ingress    = var.private_network_acl_ingress
  tags       = module.network_acl_tags.tags

  depends_on = ["aws_subnet.private"]
}

#
# R O U T I N G
###########################################################
resource "aws_route_table" "private" {
  count  = local.private_count
  vpc_id = var.vpc_id

  tags = merge(
          module.route_table_tags.tags,
          {
            "Name" = "${title(var.environment_type)} Environment - ${element(data.aws_availability_zones.availability_zones.names, count.index)}-${title(local.subnet_type)} Route Table ${count.index + 1}",
            "AZ" = element(data.aws_availability_zones.availability_zones.names, count.index)
          }
        )
}

resource "aws_route_table_association" "private" {
  count          = local.private_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  depends_on     = ["aws_subnet.private", "aws_route_table.private"]
}

resource "aws_route" "default" {
  count                  = local.private_route_count

  route_table_id =  lookup(zipmap(slice(data.aws_availability_zones.availability_zones.names,0,2), matchkeys(aws_route_table.private.*.id, aws_route_table.private.*.tags.AZ, slice(data.aws_availability_zones.availability_zones.names,0,2))), element(keys(var.az_ngw_ids), count.index))

  nat_gateway_id         = lookup(var.az_ngw_ids, element(keys(var.az_ngw_ids), count.index))
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.private"]
}
