variable "region" {
  type  = "string"
  default = "us-east-1"
}

//variable "integration_uri" {
  //type = "string"
  //default = "arn:aws:apigateway:${var.region}:s3:path/${data.aws_s3_bucket.gc-invoicedata-bucket.bucket}/real-time-invoice-data/{clientId}/{requestId}/{object}"
//}

variable "stage" {
  type = "string"
  default = "dev"
}

variable "role_name" {
    type = "string"
    default = "gc-api-gateway-role"
}

variable "environment_type" {
}
