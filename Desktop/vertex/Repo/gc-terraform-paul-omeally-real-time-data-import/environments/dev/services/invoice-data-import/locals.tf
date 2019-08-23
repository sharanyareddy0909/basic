locals {
 # The AWS region to deploy to (e.g. us-east-1)
  region     = "us-east-1"
}

locals {
  environment_type = basename(dirname(dirname(path.cwd)))
}

locals {
 # The AWS role to assume for environment to assume role.
  role_arn     = "arn:aws:iam::517433648023:role/VATAdmin"
}
