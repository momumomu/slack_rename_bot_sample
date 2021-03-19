resource "aws_ssm_parameter" "slack_channel_rename_user_oauth_token" {
  name   = "/slack_channel_rename/user_oauth_token"
  type   = "SecureString"
  value  = "dummy"
  key_id = "${aws_kms_alias.slack_channel_rename_kms_key.name}"

  lifecycle {
    #valueの変更を無視する。
    ignore_changes = [
      "value"
    ]
  }
}

resource "aws_ssm_parameter" "slack_channel_rename_signing_secret" {
  name   = "/slack_channel_rename/signing_secret"
  type   = "SecureString"
  value  = "dummy"
  key_id = "${aws_kms_alias.slack_channel_rename_kms_key.name}"

  lifecycle {
    #valueの変更を無視する。
    ignore_changes = [
      "value"
    ]
  }
}

