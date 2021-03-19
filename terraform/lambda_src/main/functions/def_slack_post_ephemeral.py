import requests
import json

#「Only visible to you」なメッセージを返す
def def_slack_post_ephemeral(response_url, message):
    post_headers = {
        "Content-Type": "application/json; charset=UTF-8",
    }

    data = {
        'text': message
    }
    
    response = requests.post(response_url, data=json.dumps(data), headers=post_headers)
    return
