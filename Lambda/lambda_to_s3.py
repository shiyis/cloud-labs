import json 
import boto3 


def lambda_handler(event, context): 

    client = boto3.client('sns')

    try: 

        size = event['Records'][0]['s3']['object']['size'] 

    except KeyError: 

        pass 

    bucket = event['Records'][0]['s3']['bucket']['name'] 

    key = event['Records'][0]['s3']['object']['key'] 

    if event['Records'][0]['eventName'] == "ObjectRemoved:Delete": 

        payload_str = "An object with name: " + key + " was deleted from bucket: " + bucket 

    else: 

        payload_str = "An object with name " + key + " and size "+ str(size) + "B was uploaded to bucket: " + bucket 

  

    print(payload_str) 

    response = client.publish(TargetArn='arn:aws:sns:us-east-1:481450237232:Lambda2Cloudwatch:701123ee-ab7a-48fe-bffd-342cce8d5ff9
',Subject='My Lambda S3 event',Message=json.dumps({'default': json.dumps(payload_str)}), 

    MessageStructure='json') 
