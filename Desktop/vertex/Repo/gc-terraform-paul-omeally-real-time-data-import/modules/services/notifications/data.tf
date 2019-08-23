data "aws_region" "current" {}

data "aws_caller_identity" "current" {}


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
data "aws_iam_policy" "AWSLambdaSQSQueueExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}


data "aws_sns_topic" "gc-realtimereportgenerationcompleted-topic" {
  name = "gc-realtimereportgenerationcompleted-topic"
}
data "aws_sns_topic" "gc-edicom-host-transmission-success-topic" {
  name = "gc-edicom-host-transmission-success-topic"
}
data "aws_sns_topic" "gc-edicom-host-transmission-failure-topic" {
  name = "gc-edicom-host-transmission-failure-topic"
}
data "aws_sns_topic" "gc-edicom-host-support-issue-topic" {
  name = "gc-edicom-host-support-issue-topic"
}