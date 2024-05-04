import os

import boto3 # AWS SDK

# EC2 Instance

def create_key_pair():
    ec2_client = boto3.client("ec2", region_name="us-east-1")
    key_pair = ec2_client.create_key_pair(KeyName="ec2-key-pair")
    private_key = key_pair["KeyMaterial"]

    # write private key to file with 400 permissions
    with os.fdopen(os.open("./aws_ec2_key.pem", os.O_WRONLY | os.O_CREAT, 0o400), "w+") as handle:
        handle.write(private_key)

# Need AMI for us-east-1
def create_instance():
    ec2_client = boto3.client("ec2", region_name="us-east-1")
    instances = ec2_client.run_instances(ImageId="ami-026b57f3c383c2eec", MinCount=1, MaxCount=1, InstanceType="t2.micro", KeyName="ec2-key-pair")
    print(instances["Instances"][0]["InstanceId"])
    

