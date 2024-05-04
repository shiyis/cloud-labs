
provider "aws" {
  region = var.main_region
}

module "vpc" {
  source = ".\\..\\modules\\vpc"
  region = var.main_region
  vpc_cidr = var.vpc_cidr
  vpc_subnet1 = var.vpc_subnet1
}

module "keypair"  {
  source = ".\\..\\modules\\ec2-keys"
  region = var.main_region
  keyname = join("_",["test",var.main_region])
}

resource "aws_instance" "my-instance" {
  count = 1
  ami           = module.vpc.ami_id
  subnet_id     = module.vpc.subnet_id
  key_name = module.keypair.keyname
  instance_type = "t2.micro"
  tags = {
    name = "Server ${count.index}"
    environment = "dev"
  }
}