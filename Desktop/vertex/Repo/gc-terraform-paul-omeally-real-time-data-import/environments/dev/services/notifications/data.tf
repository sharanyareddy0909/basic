data "aws_vpc" "vpc" {
  tags = {
    Name = local.vpc_name
  }
}