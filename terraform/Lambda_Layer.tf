resource "aws_lambda_layer_version" "requests" {
  layer_name          = "requests"
  compatible_runtimes = ["python3.6"]
  filename            = "./Lambda_Layer_source/requests.zip"
  source_code_hash    = "${filebase64sha256("./Lambda_Layer_source/requests.zip")}"
}

