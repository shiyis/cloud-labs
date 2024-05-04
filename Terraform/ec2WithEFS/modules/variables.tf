variable "user-data" {
  description = "user data for EC2 isntance to install HTTP daemon"
  type        = string
}

variable "image_id" {
  type        = string
  description = "the AMI id"
}

variable "type" {
  type = string
}

variable "az_names" {
  type = list(any)
}
