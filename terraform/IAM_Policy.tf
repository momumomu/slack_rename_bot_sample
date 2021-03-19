# Lambda(非同期処理呼び出し用)
resource "aws_iam_policy" "slack_channel_rename_Lambda_InvokeMainFunction" {
  name   = "AWSLambda_slack_channel_rename_Lambda_InvokeMainFunction"
  policy = "${data.aws_iam_policy_document.Lambda_InvokeMainFunction.json}"
}
data "aws_iam_policy_document" "Lambda_InvokeMainFunction" {
  statement {
    sid    = "Statement1"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "arn:aws:lambda:ap-northeast-1:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.slack_channel_rename_lambda_main.function_name}"
    ]
  }
}

# SSM Parameter Store復号用
resource "aws_iam_policy" "slack_channel_rename_KMS_Decrypt_ParameterStore" {
  name   = "AWSLambda_slack_channel_rename_Decrypt_ParameterStore"
  policy = "${data.aws_iam_policy_document.slack_channel_rename_KMS_Decrypt_ParameterStore.json}"
}

data "aws_iam_policy_document" "slack_channel_rename_KMS_Decrypt_ParameterStore" {
  statement {
    sid    = "Statement0"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "Statement1"
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      "${aws_kms_key.slack_channel_rename_kms_key.arn}"
    ]
  }

  statement {
    sid    = "Statement2"
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:PutParameter",
      "ssm:PutComplianceItems"
    ]
    resources = [
      "arn:aws:ssm:ap-northeast-1:${data.aws_caller_identity.current.account_id}:parameter/slack_channel_rename/*"
    ]
  }
}
