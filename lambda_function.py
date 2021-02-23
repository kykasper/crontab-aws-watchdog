import os
import json
import logging

import boto3


logger = logging.getLogger()
logger.setLevel(logging.INFO)

TOPIC_ARN = os.environ['SNS_TOPIC_ARN']
SUBJECT = 'Crontab Alert'
client = boto3.client('sns')

def lambda_handler(event, context):
    logger.info('event: {}'.format(event))
    try:
        message = event['Records'][0]['Sns']['Message']
        service_active_state, service_status = message.split('\n', 1)
        logger.info(service_active_state)

        if service_active_state != "ActiveState=active":
            response = client.publish(
                TopicArn = TOPIC_ARN,
                Message = service_status,
                Subject = SUBJECT,
            )
        logger.info('SNS Result: {}'.format(json.dumps(response)))
        return response
    except Exception as e:
        logger.error('Error: {}'.format(str(e)))