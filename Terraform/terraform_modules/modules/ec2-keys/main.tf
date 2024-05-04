provider "aws" {
  region = var.region
}

# Generate new private key
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}

# Generate a key-pair with above key
resource "aws_key_pair" "deployement" {
  key_name   = var.keyname
  public_key = tls_private_key.my_key.public_key_openssh
}

