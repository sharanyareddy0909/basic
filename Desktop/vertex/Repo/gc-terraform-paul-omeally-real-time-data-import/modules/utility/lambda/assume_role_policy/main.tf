resource "aws_iam_role" "iam_role" {

  name = "${var.role_name}"
  description = "Allows a lambda function to call AWS services on your behalf."
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = "${var.tags}"
}

# Attaches a Managed IAM Policy to an IAM role.
resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {

  count = "${length(var.policy_arns)}"

  role       = "${aws_iam_role.iam_role.name}"
  policy_arn = "${element(var.policy_arns, count.index)}"
}