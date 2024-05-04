### AZ DATA ###

data "aws_availability_zones" "available" {
  state = "available"


### EC2 INSTANCE DATA ###

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}


### OTHER MODULE CONFIG ###

module "alb_asg_ec2_efs_igw_rds" {
  source    = ".\\..\\modules\\alb_asg_ec2_efs_igw_rds"
  user-data = "user-data.sh"
  type     = "t2.micro"
  image_id = data.aws_ami.amazon-linux.id
  az_names = data.aws_availability_zones.available.names

}
