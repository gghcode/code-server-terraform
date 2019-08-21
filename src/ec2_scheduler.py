import json
import os
import boto3

KEY_STAGE_VARIABLES = 'stageVariables'
KEY_INSTANCE_ID = 'instance_id'
KEY_JSON_BODY = 'body'
KEY_ACTION = 'action'

ec2 = boto3.client('ec2')

actionFunctions = {
    "start": lambda ec2, instance_id: ec2.start_instances(InstanceIds=[instance_id]),
    "stop": lambda ec2, instance_id: ec2.stop_instances(InstanceIds=[instance_id]),
    "test": lambda ec2, instance_id: True
}

def handler(event, context):
    try:
        json_body = parse_json_body(event)

        action = json_body[KEY_ACTION]

        if not action in actionFunctions:
            raise Exception('Not allowed action...')

        actionFunc = actionFunctions[action]
        actionFunc(ec2, instance_id_from_event(event))
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'msg': 'EC2 {} successful...'.format(action)
            })
        }
    except Exception as ex:
        return {
            'statusCode': 200,
            'body': json.dumps({
                "err": str(ex)
            })
        }

def instance_id_from_event(event):
    if event[KEY_STAGE_VARIABLES] is None or not KEY_INSTANCE_ID in event[KEY_STAGE_VARIABLES]:
        raise Exception('Require instance_id stage variable...')
    
    return event[KEY_STAGE_VARIABLES][KEY_INSTANCE_ID]

def parse_json_body(event):
    if not KEY_JSON_BODY in event:
        raise Exception('Require body payload...')

    payload = event[KEY_JSON_BODY]

    json_body = payload if isinstance(payload, dict) else json.loads(payload)
    if not KEY_ACTION in json_body:
        raise Exception('Require action field...')

    return json_body
