provider "aws" {
  region = local.region

    assume_role {
    role_arn     = "arn:aws:iam::517433648023:role/VATAdmin"#data.aws_iam_role.iam_role.arn #local.role_arn

    # The session name to use when making the AssumeRole call
    session_name = "Assumed Role at ${timestamp()}"
  }
}

module "environment_type_info" {
  source = "../../../../modules/utility/environment_type_info"

  environment_type = local.environment_type
}

module "service" {
    source = "../../../../modules/services/realtime-report-generation"

    vpc_id = module.environment_type_info.attributes.vpc_id 

    environment_type = local.environment_type

    environment = local.environment

    lambda_settings = local.lambda_settings

    bucket_region = local.region
}