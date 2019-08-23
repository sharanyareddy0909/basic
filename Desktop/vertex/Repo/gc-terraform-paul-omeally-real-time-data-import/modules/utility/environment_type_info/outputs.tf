output "attributes" {
    value = lookup(local.environment_type_info_map, var.environment_type,"")
}