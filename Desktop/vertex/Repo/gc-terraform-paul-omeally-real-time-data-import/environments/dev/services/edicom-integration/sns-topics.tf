resource "aws_sns_topic" "gc-edicom-host-transmission-success-topic" {
  name = "gc-edicom-host-transmission-success-topic" 
  display_name ="EDICOM Transmission - Success"
#accept the defaults for the below    
#   delivery_policy = <<EOF
# {
#   "http": {
#     "defaultHealthyRetryPolicy": {
#       "minDelayTarget": 20,
#       "maxDelayTarget": 20,
#       "numRetries": 3,
#       "numMaxDelayRetries": 0,
#       "numNoDelayRetries": 0,
#       "numMinDelayRetries": 0,
#       "backoffFunction": "linear"
#     },
#     "disableSubscriptionOverrides": false,
#     "defaultThrottlePolicy": {
#       "maxReceivesPerSecond": 1
#     }
#   }
# }
# EOF
}

resource "aws_sns_topic" "gc-edicom-host-transmission-failure-topic" {
  name = "gc-edicom-host-transmission-failure-topic" 
  display_name ="EDICOM Transmission - Failure"
}


resource "aws_sns_topic" "gc-edicom-host-support-issue-topic" {
  name = "gc-edicom-host-support-issue-topic" 
  display_name ="EDICOM Host Issue"
}

# P E R M I S S I O N S
#         "aws:SourceArn": "${aws_instance.edicom_host_ec2_instance.arn}"
#         "aws:SourceArn": "${data.aws_instance.edicom_host_ec2_instance.arn}"
resource "aws_sns_topic_policy" "gc-edicom-host-transmission-success-topic-policy" {
  arn = "${aws_sns_topic.gc-edicom-host-transmission-success-topic.arn}"

   policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.gc-edicom-host-transmission-success-topic.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_instance.edicom_host.arn}"
        }
      }
    }
  ]
}
EOF
}

#         "aws:SourceArn": "${aws_instance.edicom_host_ec2_instance.arn}"
#         "aws:SourceArn": "${data.aws_instance.edicom_host_ec2_instance.arn}"
resource "aws_sns_topic_policy" "gc-edicom-host-transmission-failure-topic-policy" {
  arn = "${aws_sns_topic.gc-edicom-host-transmission-failure-topic.arn}"

   policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.gc-edicom-host-transmission-failure-topic.arn}",
      "Condition": {
        "ArnEquals": {
           "aws:SourceArn": "${aws_instance.edicom_host.arn}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sns_topic_policy" "gc-edicom-host-support-issue-topic-policy" {
  arn = "${aws_sns_topic.gc-edicom-host-support-issue-topic.arn}"

   policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Subscribe",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Resource": "${aws_sns_topic.gc-edicom-host-support-issue-topic.arn}",
    }
  ]
}
EOF
}