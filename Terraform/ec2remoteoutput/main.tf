data "terraform_remote_state" "keypair" {
  backend = "s3"
  config = {
    bucket = "training-bucket-demo-4345"
    key    = "ec2"
    region = "us-east-1"
  }
}

resource "aws_instance" "my_vm1" {
  ami           = "ami-026b57f3c383c2eec"
  instance_type = "t2.micro"
  key_name = data.terraform_remote_state.keypair.outputs.keyname
  tags = {
    Name = "My EC2 instance with update",
  }
}