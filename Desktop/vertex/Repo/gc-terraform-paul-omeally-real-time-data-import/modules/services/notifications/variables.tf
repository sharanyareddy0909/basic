variable "vpc_id" {
}

variable "environment_type" {
}

variable "environment" {
  description = "Environment Variables"
  default = {}
}

variable "lambda_settings" {
  type = "map"
}
variable "queue_settings" {
  type = "map"
}