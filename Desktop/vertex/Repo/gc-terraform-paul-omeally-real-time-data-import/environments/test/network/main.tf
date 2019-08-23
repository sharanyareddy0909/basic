# module "accountId_for_environment" {
#   source = "../../../modules/utility/accountIds"

#   environment_type = "${local.environment_type}"
# }

# provider "aws" {
#   region                  = "${local.region}"
#   shared_credentials_file = "${local.shared_credentials_file}"
#   profile                 = "${local.profile}"
# }

# G O T   T H E   F O L L O W I N G   E R R O R   W H E N   U S I N G
# provider.aws: The role "arn:aws:iam::517433648023:role/VATAdmin" cannot be assumed.

#   There are a number of possible causes of this - the most common are:
#     * The credentials used in order to assume the role are invalid
#     * The credentials do not have appropriate permission to assume the role
#     * The role ARN is not valid
# provider "aws" {
#   region = "${local.region}"
#     #allowed_account_ids = ["${module.accountId_for_environment.accountId}"]

#     assume_role {
#     role_arn     = "arn:aws:iam::474562475633:role/Admin"#"${data.aws_iam_role.iam_role.arn}" #"${local.role_arn}"

#     # The session name to use when making the AssumeRole call
#     session_name = "Assumed Role at ${timestamp()}"
#   }
# }

# S H O U L D   T H I S   B E   E N V I R O N M E N T   S P E C I F I C   ? ? ?
# terraform {
#   backend "s3" {
#     bucket = "gc-terraform-bucket"
#     key = "vitrimport/terraform.tfstate"
#     region = "${local.region}"
#     dynamodb_table = "gc-terraform-table"
#     encrypt = true
#     role_arn = "${local.role_arn}"
#   }
# }

provider "aws" {
  region = local.region

    assume_role {
    role_arn     = "arn:aws:iam::474562475633:role/Admin"#data.aws_iam_role.iam_role.arn #local.role_arn

    # The session name to use when making the AssumeRole call
    session_name = "Assumed Role at ${timestamp()}"
  }
}

module "vpc" {
    source = "../../../modules/network/vpc"

    environment_type = local.environment_type

    cidr_block = local.cidr_block

    instance_tenancy = local.instance_tenancy

    enable_dns_hostnames = local.enable_dns_hostnames

    enable_dns_support = local.enable_dns_support
}

module "private_subnets" {
    source = "../../../modules/network/private_subnets"

    environment_type = local.environment_type

    vpc_id = module.vpc.vpc_id
    vpc_cidr_block = module.vpc.vpc_cidr_block
}

module "public_subnets" {
    source = "../../../modules/network/public_subnets"

    environment_type = local.environment_type

    vpc_id = module.vpc.vpc_id
    vpc_cidr_block = module.vpc.vpc_cidr_block

    igw_id = module.vpc.igw_id
}

module "security_groups" {
  source = "../../../modules/network/security_groups"

  environment_type = local.environment_type

  vpc_id = module.vpc.vpc_id

  vertex_cloud_cidrs = local.vertex_cloud_cidrs
}