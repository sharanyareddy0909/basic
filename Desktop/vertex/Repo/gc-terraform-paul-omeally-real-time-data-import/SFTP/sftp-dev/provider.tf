provider "aws" {
  region = "us-east-1"
    assume_role {
    role_arn     = "arn:aws:iam::517433648023:role/VATAdmin"
    session_name = "QA"
  }
}




