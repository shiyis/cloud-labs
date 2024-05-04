### AZ DATA ###

data "aws_availability_zones" "available" {
  state = "available"
}

### EC2 INSTANCE DATA ###

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

### ROUTE TABLE DATA ###

data "aws_route_table" "route_table" {
  filter {
    name   = "association.main"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

### OTHER MODULE CONFIG ###

module "ec2" {
  source         = ".\\..\\modules\\ec2"
  vpc_subnet0_id = module.vpc.subnet0_id
  type           = "t2.micro"
  image_id       = data.aws_ami.amazon-linux.id
  vpc_id         = module.vpc.vpc_id
}

module "vpc" {
  source         = ".\\..\\modules\\vpc"
  az_names       = data.aws_availability_zones.available.names
  route_table_id = data.aws_route_table.route_table.id
}

module "efs" {
  source                 = ".\\..\\modules\\efs"
  ec2_public_ip          = module.ec2.aws_instance_public_ip
  private_key            = module.ec2.private_key
  ec2_instance           = module.ec2.aws_instance_id
  ec2_instance_subnet_id = module.ec2.aws_instance_subnet_id
  security_group_id      = module.ec2.security_group_id
}