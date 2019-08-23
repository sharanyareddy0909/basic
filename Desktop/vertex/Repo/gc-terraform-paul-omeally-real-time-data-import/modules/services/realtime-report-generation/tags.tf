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

module "bucket_tags" {
  source = "../../utility/tags"

  environment_type = var.environment_type
  service = local.service
  resource_type = "s3"
  resource_name = local.bucket.name
}