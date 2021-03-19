import hmac
import hashlib
import datetime

def def_verify_requests(slack_event, signing_secret):
    #API URLにいたずらRequestsが送信されたときに
    #https://api.slack.com/authentication/verifying-requests-from-slack
    headers = slack_event['headers']
    signature = headers["X-Slack-Signature"]
    request_ts = int(headers["X-Slack-Request-Timestamp"])
    now_ts = int(datetime.datetime.now().timestamp())
    message = "v0:{}:{}".format(headers["X-Slack-Request-Timestamp"], slack_event['body'])
    expected = "v0={}".format(hmac.new(
                    bytes(signing_secret, 'UTF-8'),
                    bytes(message, 'UTF-8'),
                    hashlib.sha256).hexdigest())
    if abs(request_ts - now_ts) > (60 * 5):
        return False
    if signature != expected:
        return False
    
    return True
