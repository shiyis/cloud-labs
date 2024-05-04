locals {
 ami      = "ami-026b57f3c383c2eec"
 type     = "t2.micro"
 name_tag = "My EC2 terraform Instance"
}



locals {
  env_tags = {
    envname = "dev"
    envteam = "devteam"
  }
}