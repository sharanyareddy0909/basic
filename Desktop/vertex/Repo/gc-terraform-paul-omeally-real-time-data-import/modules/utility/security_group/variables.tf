variable "settings" {
      type = object(
        name = string
        description = string
        vpc_id = string

        inbound_rules = list(object({
          from_port       = number
          to_port         = number
          protocol        = string
          cidr_blocks     = list(string)
        }))

        outbound_rules = list(object({
          from_port       = number
          to_port         = number
          protocol        = string
          cidr_blocks     = list(string)
        }))
      )
}


variable "tags" {
  type = "map"
}

# variable "name" {
# }

# variable "description" {
#     default = "No description provided."
# }

# variable "ingress" {
#     type = list(object({
#       from_port       = number
#       to_port         = number
#       protocol        = string
#       cidr_blocks     = list(string)
#     }))
# }

# variable "egress" {
#     type = list(object({
#       from_port       = number
#       to_port         = number
#       protocol        = string
#       cidr_blocks     = list(string)
#       prefix_list_ids = list(string)
#     }))
# }

# variable "vpc_id" {
#   default = ""
# }
