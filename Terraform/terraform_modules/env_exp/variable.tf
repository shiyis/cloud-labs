variable "main_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.23.240.0/23"
}

variable "vpc_subnet1" {
  type    = string
  default = "10.23.240.0/25"
}
