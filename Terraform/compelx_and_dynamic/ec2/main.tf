provider "aws" {
  region = "us-east-1"
}

data "aws_ssm_parameter" "ami_id" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


module "vpc" {
  /* source = "terraform-aws-modules/vpc/aws" */

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a"]
  public_subnets = ["10.0.1.0/24"]


}

module "sg" {
  source      = ".\\..\\modules\\sg"
  main_region = var.main_region
  vpcid       = module.vpc.vpc_id
  rules       = var.rules
}

resource "aws_instance" "my-instance" {
  ami             = data.aws_ssm_parameter.ami_id.value
  subnet_id       = module.vpc.public_subnets[0]
  instance_type   = "t2.micro"
  security_groups = [module.sg.securityid]
  user_data       = fileexists("script.sh") ? file("script.sh") : null
}