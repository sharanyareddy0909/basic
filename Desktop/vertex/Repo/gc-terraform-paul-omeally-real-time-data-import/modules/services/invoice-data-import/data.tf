data "aws_lambda_function" "gc-token-authorizer-function" {
  function_name = "gc-token-authorizer-function"
}

data "aws_s3_bucket" "gc-invoicedata-bucket" {
  bucket = "gc-invoicedata-bucket"
}
