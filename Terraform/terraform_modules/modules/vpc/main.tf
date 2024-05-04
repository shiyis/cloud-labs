provider "aws" {
  region = var.region
}

# Begin variable name test for keywords
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "is" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
}

data "aws_ssm_parameter" "sparta" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# End variable name test for keywords