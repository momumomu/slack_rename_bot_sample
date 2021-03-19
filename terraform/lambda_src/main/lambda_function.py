import requests
import logging
import urllib.parse
import json

#外部関数取り込み
from functions.def_get_ssm_parameter import def_get_ssm_parameter
from functions.def_slack_post_ephemeral import def_slack_post_ephemeral
from functions.def_verify_requests import def_verify_requests

# ログ設定
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handle_slack_event(slack_event: dict, context) -> str:
    slack_event_body = urllib.parse.parse_qs(slack_event['body'])
    
    #パラメータストアから値を取得
    slack_token = def_get_ssm_parameter('/slack_channel_rename/user_oauth_token', True)
    signing_secret = def_get_ssm_parameter('/slack_channel_rename/signing_secret', True)
    
    #いたずらリクエストではないか確認
    verify_result = def_verify_requests(slack_event, signing_secret)
    if verify_result == False:
        return "Slack以外の要求なので無視します"
    
    if 'channel_id' in slack_event_body:
        slack_channel_id = slack_event_body['channel_id'][0]
    else:
        err_txt = 'channel_id not found'
        return
    
    #Slash commandにチャンネル名が指定されているか確認
    if 'text' in slack_event_body:
        slack_text = slack_event_body['text'][0]
    else:
        response_url = slack_event_body["response_url"][0]
        logger.info(response_url)
        err_txt = '新しいチャンネル名が指定されてません。 `/rename-channel <変更したいチャンネル名>` といった形で指定してください:pray:'
        def_slack_post_ephemeral(response_url, err_txt)
        return
    
    #Slack APIに渡すヘッダ
    post_headers = {
        'Content-Type': 'x-www-form-urlencoded',
        "Authorization": "Bearer {0}".format(slack_token)
    }
    
    #rename処理
    url = 'https://slack.com/api/conversations.rename'
    payload = {
        "channel" : slack_channel_id,
        "name":  slack_text
    }
    response = requests.post(url, params=payload, headers=post_headers)
    logger.info(response.json())
    
    #leave処理(リネーム対象のチャンネルにinviteされていた場合)
    url = 'https://slack.com/api/conversations.leave'
    post_headers = {
        'Content-Type': 'x-www-form-urlencoded',
        "Authorization": "Bearer {0}".format(slack_token)
    }
    payload = {
        "channel" : slack_channel_id
    }
    response = requests.post(url, params=payload, headers=post_headers)
    logger.info(response.json())

    return