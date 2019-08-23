locals {
  environment_type = basename(dirname(path.cwd))
}

locals {
 # The AWS region to deploy to (e.g. us-east-1)
  region = "us-east-1"
}

locals {
  shared_credentials_file = "~/.aws/credentials"
}

locals {
  profile = local.environment_type
}

#
# V P C   S E T T I N G S
################################################################
locals {
  # CIDR for the VPC"
    cidr_block = "10.33.0.0/16"
}

locals {
  # A tenancy option for instances launched into the VPC"
    instance_tenancy = "default"
}

locals {
  # A boolean flag to enable/disable DNS hostnames in the VPC"
    enable_dns_hostnames = "true"
}

locals {
  # A boolean flag to enable/disable DNS support in the VPC"
    enable_dns_support = "true"
}

#
# S E C U R I T Y   G R O U P   S E T T I N G S
################################################################

locals {
  vertex_cloud_cidrs = {
    client_profile_endpoint_cidr = "18.215.221.159/32"
    client_profile_endpoint_cidr_failover = "34.229.26.102/32"
  }
}