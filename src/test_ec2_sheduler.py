import json
import unittest

from ec2_scheduler import handler

class HandlerTests(unittest.TestCase):
    def test_thrown_ex_when_not_contain_body(self):
        expected = {
            'statusCode': 200,
            'body': json.dumps({
                "err": 'Require body payload...'
            })
        }

        event = {}
        context = {}

        actual = handler(event, context)

        self.assertEqual(expected, actual)
    def test_thrown_ex_when_not_contain_action(self):
        expected = {
            'statusCode': 200,
            'body': json.dumps({ "err": 'Require action field...' })
        }

        event = { 'body': {} }
        context = {}

        actual = handler(event, context)

        self.assertEqual(expected, actual)
    def test_thrown_ex_when_not_allowed_action(self):
        expected = {
            'statusCode': 200,
            'body': json.dumps({ "err": 'Not allowed action...' })
        }

        event = { 'body': { 'action': 'update' }}
        context = {}

        actual = handler(event, context)

        self.assertEqual(expected, actual)

    def test_thrown_ex_when_not_contain_stageVariables(self):
        expected = {
            'statusCode': 200,
            'body': json.dumps({ "err": 'Require instance_id stage variable...' })
        }

        event = { 'body': { 'action': 'start' }, 'stageVariables': None }
        context = {}

        actual = handler(event, context)

        self.assertEqual(expected, actual)

    def test_thrown_ex_when_not_contain_instance_id(self):
        expected = {
            'statusCode': 200,
            'body': json.dumps({ "err": 'Require instance_id stage variable...' })
        }

        event = { 'body': { 'action': 'start' }, 'stageVariables': {} }
        context = {}

        actual = handler(event, context)

        self.assertEqual(expected, actual)

    def test_success(self):
        expected = {
            'statusCode': 200,
            'body': json.dumps({ 
                "msg": 'EC2 test successful...' 
            })
        }

        event = { 
            'body': { 'action': 'test' }, 
            'stageVariables': {
                'instance_id': 'test-ami'
            } 
        }
        
        context = {}

        actual = handler(event, context)

        self.assertEqual(expected, actual)

if __name__ == '__main__':  
    unittest.main()
