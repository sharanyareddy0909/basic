variable "vpc_id" {
}

variable "environment_type" {
}

variable "environment" {
  type = "map"
  description = "Environment Variables"
  default = {}
}

variable "lambda_settings" {
  type = "map"
}

variable "bucket_region" {
}

