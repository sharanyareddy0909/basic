locals {
  # By convention, name of service matches the name of the service (module's) root directory.
  service = "${basename(path.root)}"
}

#
#
#--- L A M B D A ---#

locals {
  function_name = "gc-realtimereports-function"
}
locals {
  description = "real time report transmission"
}

locals {
  handler = "RealTimeReports::RealTimeReports.Function::FunctionHandler"
}

locals {
  runtime = "dotnetcore2.1"
}


locals {
  function_role_name = "gc-realtimereports-function-role"
}
locals {
  filename = "../src/RealTimeReports/out/RealTimeReports.zip"
}

#
#
#--- L A M B D A   P O L I C I E S ---#

locals {
  lambda_policy_arns = [
    "${data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn}",
    "${data.aws_iam_policy.AWSXrayWriteOnlyAccess.arn}",
    "${data.aws_iam_policy.AWSLambdaSQSQueueExecutionRole.arn}"
  ]
}
