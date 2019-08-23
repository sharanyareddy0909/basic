# resource "aws_security_group" "security_group" {
#   name        = local.settings.name
#   description = local.settings.description
#   vpc_id      = local.settings.vpc_id

#   dynamic "ingress" {

#     for_each = local.settings.inbound_rules

#     content {
#       from_port       = ingress.from_port
#       to_port         = ingress.to_port
#       protocol        = ingress.protocol
#       cidr_blocks     = ingress.cidr_blocks
#     }
#   }

#   dynamic "egress" {

#     for_each = local.settings.outbound_rules

#     content {
#       from_port       = egress.from_port
#       to_port         = egress.to_port
#       protocol        = egress.protocol
#       cidr_blocks     = egress.cidr_blocks
#     }
#   }

#   tags = var.tags
# }