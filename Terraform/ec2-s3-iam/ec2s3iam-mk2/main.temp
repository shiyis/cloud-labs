//************ Create S3 Buckets ***************

locals {
  bucket_name = "aws-temp"
  env         = "dev"
}

resource "random_pet" "this" {
  length = 3
}

resource "aws_s3_bucket" "my_test_bucket" {
  bucket = "${local.bucket_name}-${random_pet.this.id}"
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "${local.bucket_name}-${random_pet.this.id}"
    Environment = local.env
  }
}

// *********End of Creting S3 buckets

// Create policy so EC2 can fetch data from S3
data "aws_iam_policy_document" "s3_access_policy_data" {
  statement {
    sid = "allowS3"
    actions = [
      "s3:Get*",
      "s3:Delete*",
      "s3:List*",
      "s3:Put*"
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}-${random_pet.this.id}/*",
      "arn:aws:s3:::${local.bucket_name}-${random_pet.this.id}"
    ]
  }
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3_EC2_integration_policy"
  description = "test - access to source and destination S3 bucket"
  path        = "/"

  policy = data.aws_iam_policy_document.s3_access_policy_data.json
}

## Policy Created

#### Role Creation
resource "aws_iam_role" "s3_ec2_access" {
  name        = "S3_EC2_Integration_role"
  description = "S3_ec2_accesss"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

## Role and Policy attachment

resource "aws_iam_role_policy_attachment" "S3_EC2_policy_attachment" {
  role       = aws_iam_role.s3_ec2_access.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

### Create instance profile role
resource "aws_iam_instance_profile" "ec2_instance_profile_role" {
  name = "ec2instanceprofilerolefors3"
  role = aws_iam_role.s3_ec2_access.id
}

####### Create KeyPair
# Generate new private key
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}
# Generate a key-pair with above key
resource "aws_key_pair" "deployer" {
  key_name   = "ec2-us-east-1-key1"
  public_key = tls_private_key.my_key.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.my_key.private_key_pem
  sensitive = true
}
#terraform output -raw private_key

#### Create Security Groups ####

# Deafult VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "ec2SG" {
  name        = "ec2SG"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_default_vpc.default.id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#### Create Ec2 Instances

data "aws_ami" "linux_ami" {
  most_recent = true
  owners      = ["amazon"]

filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

output "amiid"{
  value       = data.aws_ami.linux_ami.id
 description = "Instance ID"
}

locals {
  /* ami      = data.aws_ami.linux_ami.id */
  type     = "t2.micro"
  name_tag = "My EC2 terraform Instance"
}


locals {
  env_tags = {
    envname = "dev"
    envteam = "devteam"
  }
}
resource "aws_instance" "my_vm2" {
  ami                  = data.aws_ami.linux_ami.id
  instance_type        = local.type
  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.ec2SG.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile_role.id

  tags = {
    Name        = local.name_tag
    Envname     = local.env_tags.envname
    CombineText = "created using Terraform and Environment is ${local.env_tags.envname}"
  }
}