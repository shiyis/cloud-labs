variable "ami" {
   type        = string
   description = "Linux AMI ID"
  default = "ami-026b57f3c383c2eec"
}

variable "instance_type" {
   type        = string
   description = "Instance type"
  default = "t2.micro"
}

variable "name_tag" {
   type        = string
   description = "Name of the EC2 instance"
  default = "Ec2 instance from input variable"
}
