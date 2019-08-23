locals {
  # By convention, name of service matches the name of the service (module's) root directory.
  service = basename(path.module)
}

#
#
#--- L A M B D A ---#
locals {
  lambda_function = {
      name = "gc-notifications-function"
      role_name = "gc-notifications-function-role"
      handler = "Notifications::Notifications.Function::FunctionHandler"
      description = "Sends notifications to recipients based on notification type."


      deployment_package_name = "NotificationsPackage.zip"
      runtime = "dotnetcore2.1"

      policy_arns = [
        data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn,
        data.aws_iam_policy.AWSXrayWriteOnlyAccess.arn,
        data.aws_iam_policy.AWSLambdaSQSQueueExecutionRole.arn
    ]
  }
}

#
#
#--- N E T W O R K ---#

locals {
  # The network tag of the subnets to use (e.g. Private, Public)
  subnet_network_tag     = "Private"
}

locals {
  # The name tag of the security-group to use (e.g. Private, Public)
  security_group_name_tag     = "gc-intra-vpc-resources-access-sg"
}

#
#
#--- S Q S   Q U E U E S ---#

locals {
  queue_name = "gc-notifications-queue"
}

locals {
  dlq_name = "gc-notifications-dlq"
}


locals {
  fifo_queue = "false"
}

locals {
  # Can be true only for a fifo queue.
  content_based_deduplication = "false"
}

locals {
  # The visibility timeout for the queue. An integer from 0 to 43200 (12 hours).
  # The default for this attribute is 30.
  # For more information about visibility timeout, see AWS docs.
  # https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-visibility-timeout.html
  visibility_timeout_seconds = var.lambda_settings.timeout + 1
}


locals {
  # The time in seconds that the delivery of all messages in the queue will be delayed.
  # An integer from 0 to 900 (15 minutes).
  # The default for this attribute is 0 seconds.
  delay_seconds = "0"
}

locals {
  # The limit of how many bytes a message can contain before Amazon SQS rejects it.
  # An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB).
  # The default for this attribute is 262144 (256 KiB).
  max_message_size = "262144"
}

locals {
  # The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning.
  # An integer from 0 to 20 (seconds).
  # The default for this attribute is 0, meaning that the call will return immediately.
  receive_wait_time_seconds = "0"
}

#
#
#--- S N S   T O P I C   S U B S C R I P T I O N S ---#

locals {
  sns_topic_arns = [
    data.aws_sns_topic.gc-realtimereportgenerationcompleted-topic.arn,
    data.aws_sns_topic.gc-edicom-host-transmission-success-topic.arn,
    data.aws_sns_topic.gc-edicom-host-transmission-failure-topic.arn,
    data.aws_sns_topic.gc-edicom-host-support-issue-topic.arn
  ]
}