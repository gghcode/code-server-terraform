import json
import os
import boto3

instance_id = os.getenv('INSTANCE_ID', None)

actionFunctions = {
    "start": lambda ec2: ec2.start_instances(InstanceIds=[instance_id]),
    "stop": lambda ec2: ec2.stop_instances(InstanceIds=[instance_id])
}

def handler(event, context):
    if instance_id is None:
        raise Exception('Require INSTANCE_ID env...')

    if not 'action' in event:
        raise Exception('Require action argument...')

    ec2 = boto3.client('ec2')
    if event['action'] in actionFunctions:
        actionFunctions[event['action']](ec2)
    else:
        raise Exception('Not allowed action...')
    
    return {
        'statusCode': 200,
        'body': json.dumps('EC2 {} successful...'.format(event['action']))
    }
