output "arn" {
	# The Amazon Resource Name (ARN) specifying the role.
	value = "${aws_iam_role.iam_role.arn}"
}

output "create_date" {
	# The creation date of the IAM role.
	value = "${aws_iam_role.iam_role.create_date}"
}

output "description" {
	# The description of the role.
	value = "${aws_iam_role.iam_role.description}"
}

output "id" {
	# The name of the role.
	value = "${aws_iam_role.iam_role.id}"
}

output "name" {
	# The name of the role.
	value = "${aws_iam_role.iam_role.name}"
}

output "unique_id" {
	# The stable and unique string identifying the role.
	value = "${aws_iam_role.iam_role.unique_id}"
}