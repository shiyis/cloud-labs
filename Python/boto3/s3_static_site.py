# Random string because I need a bucket name

# import string
import numpy as np
from english_words import english_words_set

# arbitrary_phrase = "chessapeak_bay"
# random_string = np.random.choice(np.array(list(string.ascii_lowercase)), size=len(arbitrary_phrase))
# random_string = ''.join(i for i in random_string)

def get_sample_and_population():
    sample_size = int(np.random.rand()*10)
    population = int(np.random.rand()*10)
    if sample_size == 0:
        sample_size = int(np.random.rand()*10 + 1)
    if population <= sample_size:
        population = int(np.random.rand()*10 + 1)
    return sample_size, population

def find_word_index():
    word_index = int(np.random.sample()*100)
    return word_index

sample_size, population = get_sample_and_population()

def generate_string(sample = sample_size, pops = population):
    words = np.random.choice([list(english_words_set)[find_word_index()] for i in range(pops)], size=sample)
    words = list(dict.fromkeys(list(words)))
    try:
        if len(words) < 2:
            words = generate_string()
        else:
            words = '-'.join(i for i in words)
    except:
        words = np.random.choice([list(english_words_set)[find_word_index()] for i in range(pops)])
        words = '-'.join(i for i in words)
    
    return words

random_string = generate_string()

# Static Bucket Website

import json
import boto3

website_configuration = {
    "IndexDocument" : "index.html",
    "ErrorDocument" : "error.html"
}

bucket_policy = {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Principal": "*",
      "Resource": "arn:aws:s3:::" + random_string + "/*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Principal": "*",
      "Resource": "arn:aws:s3:::" + random_string
    }
  ]
}

bucket_policy = json.dumps(bucket_policy)

def make_bucket(bucket_name = random_string, region=None):
    if region is None:
        s3_client = boto3.client('s3')
        s3_client.create_bucket(Bucket=bucket_name)
    else:
        s3_client = boto3.client('s3', region_name=region)
        location = {'LocationConstraint': region}
        s3_client.create_bucket(Bucket=bucket_name, CreateBucketConfiguration=location)
    print(f'Bucket {bucket_name} is now available.')



def buckets_need_policies(bucket_name = random_string, policy = bucket_policy):
    s3_client = boto3.client('s3')
    s3_client.put_bucket_policy(Bucket = bucket_name, Policy = policy)
    print(f'{bucket_name} policy attached.')



def website_index_error(bucket_name = random_string):
    s3_resource = boto3.resource('s3')
    s3_resource.meta.client.upload_file('error.html', bucket_name, 'error.html')
    s3_resource.meta.client.upload_file('index.html', bucket_name, 'index.html')
    print(f'Index and Error pages are uploaded to {bucket_name}.')



def static_bucket_site(bucket_name = random_string, web_config = website_configuration):
    s3_client = boto3.client('s3')
    s3_client.put_bucket_website(Bucket = bucket_name, WebsiteConfiguration = web_config)
    print(f'{bucket_name} is now hosting a static website.')

# ...thus, because I do not want to call each function separately...
# ...probably a bad idea to do it like this though.

def run_all_the_things():
    print('Creating S3 bucket.')
    make_bucket()
    print('Attaching bucket policy')
    buckets_need_policies()
    print('Uploading index and error pages.')
    website_index_error()
    print('Loading website.')
    static_bucket_site()

run_all_the_things()