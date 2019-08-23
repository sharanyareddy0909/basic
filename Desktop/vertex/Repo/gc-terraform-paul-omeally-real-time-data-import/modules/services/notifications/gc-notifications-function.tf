module "lambda_config" {
  source = "../../utility/lambda/config"
}

module "lambda_role" {
  source = "../../utility/lambda/assume_role_policy"

  role_name = local.lambda_function.role_name
  policy_arns = local.lambda_function.policy_arns
  tags = module.role_tags.tags
}

resource "aws_lambda_function" "lambda_function" {

  function_name = local.lambda_function.name
  handler = local.lambda_function.handler
  description = local.lambda_function.description
  runtime = local.lambda_function.runtime

  s3_bucket = module.lambda_config.deployment_package_s3_bucket_name
  s3_key = local.lambda_function.deployment_package_name

  # Customizes the lifecycle behavior of the resource.
  # https://www.terraform.io/docs/configuration-0-11/resources.html#lifecycle
  lifecycle {
    # Interpolations are not currently supported in the lifecycle configuration block (see issue #3116)
    # https://github.com/hashicorp/terraform/issues/3116
    ignore_changes = ["s3_key"]
  }

  memory_size = var.lambda_settings.memory_size
  timeout = var.lambda_settings.timeout
  reserved_concurrent_executions = var.lambda_settings.reserved_concurrent_executions

  role = module.lambda_role.arn

  environment {
    variables = var.environment.variables
  }

  vpc_config {
    subnet_ids = data.aws_subnet_ids.private_subnet_ids.ids
    security_group_ids = data.aws_security_groups.security_groups.ids
  }

  tags = module.lambda_tags.tags
}

resource "aws_iam_role_policy" "iam_role_policy" {
    name = "ses"
    role = module.lambda_role.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": "arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:identity/*@anexinet.com",
            "Effect": "Allow"
        }
    ]
}
EOF
}