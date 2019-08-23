resource "aws_sqs_queue" "sqs_queue" {
  name                          = local.queue_name
  fifo_queue                    = local.fifo_queue
  content_based_deduplication   = local.fifo_queue == "true" ? local.content_based_deduplication : "false"
  visibility_timeout_seconds    = local.visibility_timeout_seconds
  delay_seconds                 = local.delay_seconds
  max_message_size              = local.max_message_size
  message_retention_seconds     = var.queue_settings["message_retention_seconds_in_queue"]
  receive_wait_time_seconds     = local.receive_wait_time_seconds
  redrive_policy                = <<EOF
{
	"deadLetterTargetArn": "${aws_sqs_queue.sqs_dlq.arn}",
	"maxReceiveCount": "${var.queue_settings["maxReceiveCount"]}"
}
EOF

  tags = module.queue_tags.tags
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.sqs_queue.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": aws_sqs_queue.sqs_queue.arn,
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:gc-*-topic"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sqs_queue" "sqs_dlq" {

  name                          = local.dlq_name
  fifo_queue                    = local.fifo_queue
  content_based_deduplication   = local.fifo_queue == "true" ? local.content_based_deduplication : "false"
  visibility_timeout_seconds    = local.visibility_timeout_seconds
  delay_seconds                 = local.delay_seconds
  max_message_size              = local.max_message_size
  message_retention_seconds     = var.queue_settings["message_retention_seconds_in_queue"] + var.queue_settings["additional_message_retention_seconds_in_dlq"]
  receive_wait_time_seconds     = local.receive_wait_time_seconds

  tags = module.dlq_tags.tags
}

resource "aws_sqs_queue_policy" "sqs_dlq_policy" {
  queue_url = aws_sqs_queue.sqs_dlq.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "sqs.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": aws_sqs_queue.sqs_dlq.arn,
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sqs_queue.sqs_queue.arn}"",
        }
      }
    }
  ]
}
EOF
}


resource "aws_sns_topic_subscription" "sns_topic_subscription" {

  count = length(local.sns_topic_arns)

  topic_arn = element(local.sns_topic_arns, count.index)
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_queue.arn
}