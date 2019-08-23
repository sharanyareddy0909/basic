provider "aws" {
  region = "${local.region}"
    assume_role {
    role_arn     = "${local.role_arn}"
    session_name = "Assumed Role at ${timestamp()}"
  }
}

terraform {
  backend "s3" {
    bucket = "gc-terraform-bucket"
    key = "realtime-invoice/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "gc-terraform-table"
    encrypt = true
    role_arn = "arn:aws:iam::517433648023:role/VATAdmin"
  }
}
