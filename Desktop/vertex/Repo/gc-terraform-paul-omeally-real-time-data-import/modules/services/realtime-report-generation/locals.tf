locals {
  # By convention, name of service matches the name of the service (module's) root directory.
  service = basename(path.module)
}

#
#
#--- L A M B D A ---#
locals {
  lambda_function = {
      name = "gc-realtimereportgeneration-function"
      role_name = "gc-realtimereportgeneration-function-role"
      handler = "RealtimeReportGeneration::RealtimeReportGeneration.Function::FunctionHandler"
      description = "Kicks off report generation for any eligible invoices."


      deployment_package_name = "RealtimeReportGeneration.zip"
      runtime = "dotnetcore2.1"

      policy_arns = [
        data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn,
        data.aws_iam_policy.AWSXrayWriteOnlyAccess.arn
    ]
  }
}



#
#
#--- S N S   T O P I C S ---#

locals {
  topic_name = "gc-realtimereportgenerationcompleted-topic"
}

#
#
#--- N E T W O R K ---#

locals {
  # The network tag of the subnets to use (e.g. Private, Public)
  subnet_network_tag = "Private"
}

locals {
  # The name tag of the security-group to use (e.g. Private, Public)
  security_group_name_tag = "gc-intra-vpc-resources-access-sg"
}

#
#
#--- S 3 ---#
locals {
  bucket = {
    name = "gc-realtimereports-bucket-${var.environment_type}"
    region = var.bucket_region
    acl = "private"
    force_destroy = false
  }
}