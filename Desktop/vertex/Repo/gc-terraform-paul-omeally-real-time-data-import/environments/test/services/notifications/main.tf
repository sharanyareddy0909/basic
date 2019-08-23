provider "aws" {
  region = local.region

    assume_role {
    role_arn     = "arn:aws:iam::474562475633:role/Admin"#data.aws_iam_role.iam_role.arn #local.role_arn

    # The session name to use when making the AssumeRole call
    session_name = "Assumed Role at ${timestamp()}"
  }
}

module "service" {
    source = "../../../../modules/services/notifications"

    vpc_id = data.aws_vpc.vpc.id

    environment_type = local.environment_type

    environment = local.environment

    lambda_settings = local.lambda_settings

    queue_settings = local.queue_settings
}