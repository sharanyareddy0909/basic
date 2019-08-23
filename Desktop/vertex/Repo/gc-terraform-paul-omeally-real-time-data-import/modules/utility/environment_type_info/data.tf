data "aws_vpc" "vpc" {
  tags = {
    Name = lower(var.environment_type) == "dev" ? "LowerEnvironment-VPC" : "${title(var.environment_type)} Environment VPC"
  }
}