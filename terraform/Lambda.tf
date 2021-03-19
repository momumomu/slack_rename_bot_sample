#Slackで呼ばれる方
resource "aws_lambda_function" "slack_channel_rename_lambda_incoming_main" {
  publish          = true
  runtime          = "python3.6"
  function_name    = "slack_channel_rename_incoming_main"
  filename         = "./lambda_src/upload/incoming_main.zip"
  source_code_hash = "${data.archive_file.slack_channel_rename_lambda_incoming_main.output_base64sha256}"
  role             = "${aws_iam_role.slack_channel_rename_iam_role.arn}"
  handler          = "lambda_function.handle_slack_event"
  timeout          = 3
  layers           = ["${aws_lambda_layer_version.requests.arn}"]
}

data "archive_file" "slack_channel_rename_lambda_incoming_main" {
  type        = "zip"
  source_dir  = "./lambda_src/incoming_main"
  output_path = "./lambda_src/upload/incoming_main.zip"
}

#incoming_mainから呼ばれる方
resource "aws_lambda_function" "slack_channel_rename_lambda_main" {
  publish          = true
  runtime          = "python3.6"
  function_name    = "slack_channel_rename_main"
  filename         = "./lambda_src/upload/main.zip"
  source_code_hash = "${data.archive_file.slack_channel_rename_lambda_main.output_base64sha256}"
  role             = "${aws_iam_role.slack_channel_rename_iam_role.arn}"
  handler          = "lambda_function.handle_slack_event"
  timeout          = 900
  layers           = ["${aws_lambda_layer_version.requests.arn}"]
}

data "archive_file" "slack_channel_rename_lambda_main" {
  type        = "zip"
  source_dir  = "./lambda_src/main"
  output_path = "./lambda_src/upload/main.zip"
}

