/*    
TODO:  This collection of scripts can be wrapped in an Terraform module.
        https://www.terraform.io/docs/modules/index.html

-------------------------------------------------------------------------------------------------------------
DEPENDENCIES 
    These scripts currently depend on:
    1.) an AMI that has been shared only between Development and Experimental
    2.) a cross-cutting/shared security group to allow RDP via VPN (see "selected_sg_inbound" in data.tf)
-------------------------------------------------------------------------------------------------------------
*/         
provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "Development"
}

terraform {
  backend "s3" {
    bucket = "gc-terraform-bucket"
    key = "edicomhost/terraform.tfstate"  #<- Change for each terraform script set.
    region = "us-east-1"
    dynamodb_table = "gc-terraform-table"
    encrypt = true
    shared_credentials_file = "~/.aws/credentials"
    profile = "Development"
  }
}


