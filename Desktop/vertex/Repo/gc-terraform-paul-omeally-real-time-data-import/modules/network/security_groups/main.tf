module "security_group_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "security group"
}



# module "environment_type_info" {
#   source = "../../utility/environment_type_info"

#   environment_type = var.environment_type
# }


# module "security_groups" {
#   source = "../../utility/security_group"

#   count = length(local.security_groups)

#   settings = element(local.security_groups, count.index)

#   tags = merge(module.security_group_tags.tags,map("Name", element(local.security_groups, count.index).name))
# }

resource "aws_security_group" "security_group" {

  count = length(local.security_groups)

  name        = element(local.security_groups, count.index).name
  description = element(local.security_groups, count.index).description
  vpc_id      = element(local.security_groups, count.index).vpc_id

  dynamic "ingress" {

    for_each = element(local.security_groups, count.index).inbound_rules

    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {

    for_each = element(local.security_groups, count.index).outbound_rules

    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
    }
  }

  tags = merge(module.security_group_tags.tags,map("Name", element(local.security_groups, count.index).name))
}