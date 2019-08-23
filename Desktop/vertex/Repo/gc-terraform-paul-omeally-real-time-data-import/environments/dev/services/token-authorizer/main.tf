module "gc-token-authorizer-function" {
    source = "../../../../modules/services/token-authorizer"

    environment_type = local.environment_type

    environment = local.environment

    lambda_settings = local.lambda_settings
}
