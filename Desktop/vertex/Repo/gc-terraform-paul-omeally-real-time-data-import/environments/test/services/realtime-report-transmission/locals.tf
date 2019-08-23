locals {
  environment_type = basename(dirname(dirname(path.cwd)))
}

locals {
 # The AWS region to deploy to (e.g. us-east-1)
  region     = "us-east-1"
}

locals {
 # The AWS role to assume for environment to assume role.
  role_arn     = "arn:aws:iam::474562475633:role/Admin"
}
locals {
  vpc_name = "LowerEnvironment-VPC" #title(local.environment_type)} Environment VPC"
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
                DEBUG = "1"
                //BucketName = "${aws_s3_bucket.gc-real-time-reports-bucket-dev.id}"
                //TableName = "${aws_dynamodb_table.gc-realtimereports-table.id}"
                RealTimeFilePathTemplate = "{ClientId}/{JobId}/companyreportfolder/{Key}"
                AppStreamFilePathTemplate = "zero/one/{UserHash}/three/four/{ClientId}/{JobId}/{Key}"
        }
    }
}


