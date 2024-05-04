variable "user-data" {
  description = "user data for EC2 isntance to install HTTP daemon"
  type        = string
}

/* variable "public_subnets" {
  type = list(any)
} */

/* variable "vpc_id" {
  type        = string
  description = "the VPC id"
} */

variable "image_id" {
  type        = string
  description = "the AMI id"
}

/* variable "route_table_id" {
  type = string
} */

variable "type" {
  type = string
}

variable "az_names" {
  type = list(any)
}



/* variable "project" {
  description = "Map of project names to configuration."
  type        = map(any)

  default = {
    client-webapp = {
      public_subnets_per_vpc  = 2,
      private_subnets_per_vpc = 2,
      instances_per_subnet    = 2,
      instance_type           = "t2.micro",
      environment             = "dev"
    }
  }
} */
