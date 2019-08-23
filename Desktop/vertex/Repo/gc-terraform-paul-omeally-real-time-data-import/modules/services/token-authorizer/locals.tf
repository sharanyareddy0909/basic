locals {
  # By convention, name of service matches the name of the service (module's) root directory.
  service = "${basename(path.root)}"
}

#
#
#--- L A M B D A ---#

locals {
  function_name = "gc-token-authorizer-function"
}

locals {
  function_role_name = "gc-token-authorizer-function-role"
}
locals {
  fileName = "../src/TokenAuthorizer/out/TokenAuthorizer.zip"
}

#
#
#--- L A M B D A   P O L I C I E S ---#

locals {
  lambda_policy_arns = [
    "${data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn}",
    "${data.aws_iam_policy.AWSXrayWriteOnlyAccess.arn}"
  ]
}
