output "az_subnet_ids" {
  value       = zipmap(slice(data.aws_availability_zones.availability_zones.names,0,2), aws_subnet.public.*.id)
  description = "Map of AZ names to subnet IDs"
}

output "az_route_table_ids" {
  value       = zipmap(slice(data.aws_availability_zones.availability_zones.names,0,2), aws_route_table.public.*.id)
  description = " Map of AZ names to Route Table IDs"
}

# az_ngw_ids is also listed as an input to this module, thus the caller already knows its value.
# output "az_ngw_ids" {
#   value       = zipmap(data.aws_availability_zones.availability_zones.names, coalescelist(aws_nat_gateway.public.*.id, local.dummy_az_ngw_ids))
#   description = "Map of AZ names to NAT Gateway IDs (only for public subnets)"
# }


output "az_subnet_arns" {
  value       = zipmap(slice(data.aws_availability_zones.availability_zones.names,0,2), aws_subnet.public.*.arn)
  description = "Map of AZ names to subnet ARNs"
}
