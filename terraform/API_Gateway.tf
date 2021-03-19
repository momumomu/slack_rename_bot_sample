resource "aws_api_gateway_rest_api" "slack_channel_rename_api_gateway" {
  name = "slack_channel_rename_api_gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "slack_channel_rename_api_gateway" {
  rest_api_id = "${aws_api_gateway_rest_api.slack_channel_rename_api_gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.slack_channel_rename_api_gateway.root_resource_id}"
  path_part   = "resource"
}

resource "aws_api_gateway_method" "slack_channel_rename_api_gateway" {
  rest_api_id   = "${aws_api_gateway_rest_api.slack_channel_rename_api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.slack_channel_rename_api_gateway.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "slack_channel_rename_api_gateway" {
  rest_api_id             = "${aws_api_gateway_rest_api.slack_channel_rename_api_gateway.id}"
  resource_id             = "${aws_api_gateway_resource.slack_channel_rename_api_gateway.id}"
  http_method             = "${aws_api_gateway_method.slack_channel_rename_api_gateway.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.slack_channel_rename_lambda_incoming_main.invoke_arn}"
  content_handling        = "CONVERT_TO_TEXT"
  request_templates = {}
}

resource "aws_api_gateway_method_response" "slack_channel_rename_api_gateway" {
  rest_api_id = "${aws_api_gateway_rest_api.slack_channel_rename_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.slack_channel_rename_api_gateway.id}"
  http_method = "${aws_api_gateway_method.slack_channel_rename_api_gateway.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "slack_channel_rename_api_gateway" {
  depends_on  = ["aws_api_gateway_integration.slack_channel_rename_api_gateway"]
  rest_api_id = "${aws_api_gateway_rest_api.slack_channel_rename_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.slack_channel_rename_api_gateway.id}"
  http_method = "${aws_api_gateway_method.slack_channel_rename_api_gateway.http_method}"
  status_code = "${aws_api_gateway_method_response.slack_channel_rename_api_gateway.status_code}"
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_deployment" "slack_channel_rename_api_gateway" {
  depends_on  = ["aws_api_gateway_integration.slack_channel_rename_api_gateway"]
  rest_api_id = "${aws_api_gateway_rest_api.slack_channel_rename_api_gateway.id}"
  stage_name  = "release"
}

resource "aws_lambda_permission" "slack_channel_rename_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.slack_channel_rename_lambda_incoming_main.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:ap-northeast-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.slack_channel_rename_api_gateway.id}/*/${aws_api_gateway_method.slack_channel_rename_api_gateway.http_method}${aws_api_gateway_resource.slack_channel_rename_api_gateway.path}"
}

