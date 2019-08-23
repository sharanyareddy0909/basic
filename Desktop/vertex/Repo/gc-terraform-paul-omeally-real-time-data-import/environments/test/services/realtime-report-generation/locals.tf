locals {
  role_arn = "arn:aws:iam::474562475633:role/Admin"#data.aws_iam_role.iam_role.arn #local.role_arn
}

locals {
  environment_type = basename(dirname(dirname(path.cwd)))
}

locals {
 # The AWS region to deploy to (e.g. us-east-1)
  region     = "us-east-1"
}

locals {
  vpc_name = "${title(local.environment_type)} Environment VPC"
}

locals {
  # DEVELOPER'S NOTE:
  # While one can argue that these settings should be sourced
  # at the service level, it is also true that because they
  # influence billing/cost they may need to vary per environment.
  lambda_settings = {
    memory_size = "256"
    timeout = "30"
    reserved_concurrent_executions = "3"
  }
}

locals {

    environment = {
        variables = {
        RealtimeReportGenerationUri = "https://87fzuetc0c.execute-api.us-east-1.amazonaws.com/dev/realtime-reports"
        }
    }
}