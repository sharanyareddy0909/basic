module "role_tags" {
  source = "../../utility/tags"

  environment_type = "${var.environment_type}"
  service = "${local.service}"
  resource_type = "role"
  resource_name = "${local.function_role_name}"
}

module "lambda_role" {
  source = "../../utility/lambda/assume_role_policy"

  role_name = "${local.function_role_name}"
  policy_arns = "${local.lambda_policy_arns}"
  tags = "${module.role_tags.tags}"
}

module "lambda_tags" {
  source = "../../utility/tags"

  environment_type = "${var.environment_type}"
  service = "${local.service}"
  resource_type = "function"
  resource_name = "${local.function_name}"
}

#-- Get AppStream S3 Bucket
# data "aws_s3_bucket" "selected" {
#   tags = {
#     Name = "${var.name_tag}"
#   }
# }



# Attach VPC policy if we were given any VPC sgs
resource "aws_iam_role_policy_attachment" "vpc_attach" {
  role       = module.lambda_role.id
  policy_arn = "${data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn}"
}


# Attach X-Ray policy if enabled
resource "aws_iam_role_policy_attachment" "xray_attach" {
  role       = module.lambda_role.id
  policy_arn = "${data.aws_iam_policy.AWSXrayWriteOnlyAccess.arn}"
}

resource "aws_iam_role_policy" "gc-realtimereports-function-role-log-policy" {
  name = "gc-realtimereports-function-role-log-policy"
  role = module.lambda_role.id

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "gc-realtimereports-function-role-s3-policy" {
  name = "gc-realtimereports-function-role-s3-policy"
  role = module.lambda_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:PutObjectTagging",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::*/*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "gc-realtimereports-function-role-sqs-policy" {
  name = "gc-realtimereports-function-role-sqs-policy"
  role = module.lambda_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sqs:SendMessage"
            ],
            "Resource": "${aws_sqs_queue.gc-realtimereports-deadletterqueue.arn}",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "gc-realtimereports-function-role-dynamodb-policy" {
  name = "gc-realtimereports-function-role-dynamodb-policy"
  role =  module.lambda_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:DescribeTable"
            ],
            "Resource": "${aws_dynamodb_table.gc-realtimereports-table.arn}",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_lambda_function" "gc-realtimereports-function" {

  function_name = local.function_name
  description = local.description
  # The bucket name as created earlier with "aws s3api create-bucket"
  filename = local.filename

  # "main" is the filename within the zip file (index.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = local.handler

  runtime     = local.runtime
  memory_size = var.lambda_settings.memory_size
  timeout = var.lambda_settings.timeout

  role = module.lambda_role.arn
  environment {
    variables = var.environment.variables
  }

  tracing_config {
    mode = "Active"
  }
}

resource "aws_sqs_queue" "gc-realtimereports-deadletterqueue" {
  name = "gc-realtimereports-deadletterqueue"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.gc-realtimereports-function.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::appstream2-36fb080bb8-us-east-1-517433648023"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "appstream2-36fb080bb8-us-east-1-517433648023"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.gc-realtimereports-function.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = "_rt.xml"
  }
}

resource "aws_s3_bucket_notification" "realtime_bucket_notification" {
  bucket = "gc-realtimereports-bucket"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.gc-realtimereports-function.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = "_rt.xml"
  }
}

resource "aws_s3_bucket" "gc-real-time-reports-bucket-dev" {
  bucket = "gc-real-time-reports-bucket-dev"
  acl    = "private"

  #force_destroy = true
}

resource "aws_sqs_queue" "gc-realtimereports-to-edicom-queue" {
  name = "gc-realtimereports-to-edicom-queue"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:gc-realtimereports-to-edicom-queue",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.gc-real-time-reports-bucket-dev.arn}" }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_notification" "edicom-sqs-notification" {
  bucket = "${aws_s3_bucket.gc-real-time-reports-bucket-dev.id}"

  queue {
    queue_arn = "${aws_sqs_queue.gc-realtimereports-to-edicom-queue.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = "_rt.xml"
  }
}

resource "aws_dynamodb_table" "gc-realtimereports-table" {
  name = "gc-realtimereports-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "TransmissionId"

  attribute {
    name = "TransmissionId"
    type = "S"
  }

  tags = {
    Name        = "gc-realtimereports-table"
    Environment = "dev"
  }
}
