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

variable "email" {
    type        = string
    description = "subscription email"
   default = "jevon.morris@ctuonline.edu"
}

variable "protocol" {
    # type = string
    default = "sns"
}

variable "sns_name" {
    description = "Name of the SNS Topic to be created"
    default = "my_first_sns"
}
