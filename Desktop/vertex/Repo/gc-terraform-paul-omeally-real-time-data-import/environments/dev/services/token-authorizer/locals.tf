
locals {
  environment_type = basename(dirname(dirname(path.cwd)))
}

locals {
 # The AWS role to assume for environment to assume role.
  role_arn     = "arn:aws:iam::517433648023:role/VATAdmin"
}

locals {
 # The AWS region to deploy to (e.g. us-east-1)
  region     = "us-east-1"
}

locals {

    environment = {
        variables = {
        AuthServerClientProfileUri = "https://devapi.vertexsmb.com/site/globalcompliance/clientprofile"
        }
    }
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
