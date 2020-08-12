import json
import logging
import os

from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

WEBHOOK_URL = os.environ['WEBHOOK_URL']

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    alarm = json.loads(event['Records'][0]['Sns']['Message'])
    logger.info("Message: " + str(alarm))

    alarm_name = alarm['AlarmName']
    old_state = alarm['OldStateValue']
    new_state = alarm['NewStateValue']
    reason = alarm['NewStateReason']

    # we don't need such alarms
    if old_state == "INSUFFICIENT_DATA" and new_state == "OK":
        return

    # set the color of our message (general green, in case of alarm red)
    alarm_color = "64a837"
    if new_state == "ALARM":
        alarm_color = "d63333"

    message = {
        "@context": "https://schema.org/extensions",
        "@type": "MessageCard",
        "themeColor": alarm_color,
        "title": alarm_name + ": " + old_state + " -> " + new_state,
        "text": reason
    }

    req = Request(WEBHOOK_URL, json.dumps(message).encode('utf-8'))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted")
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)