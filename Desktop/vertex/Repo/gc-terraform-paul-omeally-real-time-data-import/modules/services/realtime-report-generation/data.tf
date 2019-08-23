#-- Get Subnet List
data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = var.vpc_id

  tags = {
    Network = local.subnet_network_tag
  }
}

data "aws_security_groups" "security_groups" {
  tags = {
    Name = local.security_group_name_tag
  }
}

data "aws_iam_policy" "AWSLambdaVPCAccessExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
data "aws_iam_policy" "AWSXrayWriteOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}


data "aws_sns_topic" "sns_topic" {
  name = "gc-realtime-invoice-data-ready-for-transmission-topic"
}

data "aws_instance" "instance" {

  filter {
    name   = "tag:Name"
    values = ["gc-vitr-api-ec2"]
  }
}