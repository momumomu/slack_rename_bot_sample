resource "aws_iam_role" "slack_channel_rename_iam_role" {
  name               = "AWSLambda_slack_channel_rename"
  path               = "/"
  description        = "AWSLambda_slack_channel_rename"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#AttatchPolicy
locals {
  slack_channel_rename_iam_role = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "${aws_iam_policy.slack_channel_rename_Lambda_InvokeMainFunction.arn}",
    "${aws_iam_policy.slack_channel_rename_KMS_Decrypt_ParameterStore.arn}"
  ]
}

resource "aws_iam_role_policy_attachment" "slack_channel_rename_iam_role" {
  role       = "${aws_iam_role.slack_channel_rename_iam_role.name}"
  count      = "${length(local.slack_channel_rename_iam_role)}"
  policy_arn = "${local.slack_channel_rename_iam_role[count.index]}"
}

