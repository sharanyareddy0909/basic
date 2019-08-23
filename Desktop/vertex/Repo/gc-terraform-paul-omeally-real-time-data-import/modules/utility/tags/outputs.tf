output "tags" {
    type = map
    value = "${merge(
                 map("Environment_Type", var.environment_type),
                 map("Service", var.service),
                 zipmap(
                                compact(split(",",  var.resource_type == "" ? "" :  "Tier" )),
                                compact(split(",",  var.resource_type == "" ? "" :  var.resource_type))
                     ),
                 zipmap(
                                compact(split(",",  var.resource_name == "" ? "" :  "Name" )),
                                compact(split(",",  var.resource_name == "" ? "" :  var.resource_name))
                     ),
                 var.additional_attributes
                )}"
}