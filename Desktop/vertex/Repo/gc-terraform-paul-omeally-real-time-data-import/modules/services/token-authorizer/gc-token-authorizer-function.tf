
module "role_tags" {
  source = "../../utility/tags"

  environment_type = "${var.environment_type}"
  service = "${local.service}"
  resource_type = "role"
  resource_name = "${local.function_role_name}"
}

module "lambda_role" {
  source = "../../utility/lambda/assume_role_policy"

  role_name = "${local.function_role_name}"
  policy_arns = "${local.lambda_policy_arns}"
  tags = "${module.role_tags.tags}"
}

module "lambda_tags" {
  source = "../../utility/tags"

  environment_type = "${var.environment_type}"
  service = "${local.service}"
  resource_type = "function"
  resource_name = "${local.function_name}"
}

resource "aws_lambda_function" "gc-token-authorizer-function" {
  //filename         = "gc-token-authorizer-function.zip"
  function_name    = "${local.function_name}"
  role             = "${module.lambda_role.arn}"
  handler          = "TokenAuthorizer::TokenAuthorizer.Function::FunctionHandler"
  filename =         "${local.fileName}"
  runtime          = "dotnetcore2.1"
  memory_size = "${var.lambda_settings["memory_size"]}"
  timeout = "${var.lambda_settings["timeout"]}"
  reserved_concurrent_executions = "${var.lambda_settings["reserved_concurrent_executions"]}"
  environment {
    variables = var.environment.variables
  }

}

resource "aws_iam_role_policy" "gc-token-authorizer-function-role-policy" {
    name = "gc-token-authorizer-function-role-policy"
    role = "${module.lambda_role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*",
            "Effect": "Allow"
        }
    ]
}
EOF
}
