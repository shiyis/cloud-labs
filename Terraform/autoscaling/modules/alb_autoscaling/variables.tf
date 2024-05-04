variable "user-data" { 
    description = "user data for EC2 isntance"
    type = string
}

variable "public_subnets" {
  type        = list
  description = "list of subnets for the vpc"
}

variable "vpc_id" {
  type        = string
  description = "the vpc id"
}

variable "image_id" {
  type        = string
  description = "the AMI id"
}
