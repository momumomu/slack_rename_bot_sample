import boto3
import json
import logging
import urllib.parse

# ログ設定
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handle_slack_event(slack_event: dict, context) -> str:
    slack_event_body = urllib.parse.parse_qs(slack_event['body'])

    #リトライ時は終了
    if "X-Slack-Retry-Num" in slack_event['headers']:
        return {"statusCode": 200, 'body': "ok"}
    
    # mainで実行するSlack関数をバックグラウンドで非同期呼び出し(Slackの仕様により3秒以内にreturn応答を返す必要があるため)
    response = boto3.client('lambda').invoke(
        FunctionName='slack_channel_rename_main',
        InvocationType='Event',
        Payload=(json.dumps(slack_event))
    )
    
    # Slack側に正常終了した旨を返さないと再送してくるので返す。
    return {"statusCode": 200, 'body': "OK"}
