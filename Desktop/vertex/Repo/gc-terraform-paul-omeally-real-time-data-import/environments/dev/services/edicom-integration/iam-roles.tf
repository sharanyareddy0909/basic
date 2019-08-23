resource "aws_iam_role" "gc-edicom-host-role" {
  name = "gc-edicom-host-role"
  description = "Consolidated permissions to AWS resoures required for full operation of the EDICOM Host EC2 Instance"
  
  tags = "${merge(map("Name", "gc-edicom-host-role"), 
                  map("Tier","IAM"),
                  local.common_tags)}"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "gc-edicom-host-log-policy" {
  name = "gc-edicom-host-log-policy"
  role = "${aws_iam_role.gc-edicom-host-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "cloudwatch:PutMetricData",
                "logs:DescribeLogGroups",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "gc-edicom-host-s3-read-policy" {
  name = "gc-edicom-host-s3-read-policy"
  role = "${aws_iam_role.gc-edicom-host-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectTagging",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::*/*",
                "arn:aws:s3:::gc-real-time-reports-bucket-dev"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "gc-edicom-host-s3-write-policy" {
  name = "gc-edicom-host-s3-write-policy"
  role = "${aws_iam_role.gc-edicom-host-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:PutObject",
                "s3:PutObjectTagging"
            ],
            "Resource": "arn:aws:s3:::gc-real-time-results-bucket-dev/*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "gc-edicom-host-sqs-policy" {
  name = "gc-edicom-host-sqs-policy"
  role = "${aws_iam_role.gc-edicom-host-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:ChangeMessageVisibility",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:GetQueueUrl"
            ],
            "Resource": "arn:aws:sqs:::gc-realtimereports-to-edicom-queue",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "gc-edicom-host-sns-publish-policy" {
  name = "gc-edicom-host-sns-publish-policy"
  role = "${aws_iam_role.gc-edicom-host-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": [
                "arn:aws:sns:*:*:gc-edicom-host-transmission-failure-topic",
                "arn:aws:sns:*:*:gc-edicom-host-transmission-success-topic",
                "arn:aws:sns:*:*:gc-edicom-host-support-issue-topic"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "sns:ListTopics",
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_instance_profile" "gc-edicom-host-role-instance-profile" {
  name = "gc-edicom-host-role-instance-profile"
  role = "${aws_iam_role.gc-edicom-host-role.name}"
}

