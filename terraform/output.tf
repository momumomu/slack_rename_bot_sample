output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.slack_channel_rename_api_gateway.invoke_url}${aws_api_gateway_resource.slack_channel_rename_api_gateway.path}"
}

// output "iddd" {
//   value = "${aws_api_gateway_resource.slack_channel_rename_api_gateway.id}"
// }

// output "pathh" {
//   value = "${aws_api_gateway_resource.slack_channel_rename_api_gateway.path}"
// }
