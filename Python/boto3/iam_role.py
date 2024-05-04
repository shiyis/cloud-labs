import json

import boto3

# IAM Role

def create_iam_role():
    iam = boto3.client("iam")
    assume_role_policy_document = json.dumps({
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
            }
        ]
    })

    response = iam.create_role(
        RoleName = "LambdaExecuteRole",
        AssumeRolePolicyDocument = assume_role_policy_document
    )

    return response["Role"]["RoleName"]


# IAM Policy for S3 bucket access

def create_iam_policy():
    # Create IAM client
    iam = boto3.client('iam')
    
    # Create a policy
    my_managed_policy = { 
        "Version": "2012-10-17", 
        "Statement": [ 
            {
                "Effect": "Allow", 
                "Action": "s3:GetObject", 
                "Principal": "*", 
                "Resource": "arn:aws:s3:::jmlab20220919/*" 
            }, 
            { 
                "Effect": "Allow", 
                "Action": "s3:ListBucket", 
                "Principal": "*", 
                "Resource": "arn:aws:s3:::jmlab20220919" 
            } 
        ] 
    }   
    response = iam.create_policy(
        PolicyName='S3bucketAccessPolicy',
        PolicyDocument=json.dumps(my_managed_policy)
    )
    print(response)



