module "role_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "role"
  resource_name = local.lambda_function.role_name
}

module "lambda_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "function"
  resource_name = local.lambda_function.name
}

module "queue_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "queue"
  resource_name = local.queue_name
}

module "dlq_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "queue"
  resource_name = local.dlq_name
}