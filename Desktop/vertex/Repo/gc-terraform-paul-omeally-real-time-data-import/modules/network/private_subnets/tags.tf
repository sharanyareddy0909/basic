module "subnet_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "subnet"
  additional_attributes = map("AccountId", data.aws_caller_identity.current.account_id)
}

module "network_acl_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "network_acl"
}

module "route_table_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "route_table"
}