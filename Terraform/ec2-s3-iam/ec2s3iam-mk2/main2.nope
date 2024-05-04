
//***************** all sunbet IDs ************

data "aws_subnet_ids" "all_subnet" {
  vpc_id = "vpc-01f4105064968b0e6"
}

locals {
  all_subnet_ids = sort(data.aws_subnet_ids.all_subnet.ids)
  first_subnet_id  = local.all_subnet_ids[0]
  other_subnet_ids = setsubtract(local.all_subnet_ids, toset([local.first_subnet_id]))
}

output "all_subnet_ids" {
  value = local.all_subnet_ids
  description = "all_subnet_ids"
}

//***************** end all sunbet IDs ************

