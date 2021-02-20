import json
import boto3

TOPIC_ARN = 'arn:aws:sns:ap-northeast-1:953626632882:alert-notification'
subject = 'TestWatchdog'
client = boto3.client('sns')

def lambda_handler(event, context):
    message = event['Records'][0]['Sns']['Message']
    print("From SNS: " + message)

    if message != "Running":
        response = client.publish(
            TopicArn = TOPIC_ARN,
            Message = message,
            Subject = subject,
        )
    print(json.dumps(response))
    return response
