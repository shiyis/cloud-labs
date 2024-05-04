
resource "aws_instance" "my_vm2" {
 ami           = local.ami
 instance_type = local.type

 tags = {
   Name = local.name_tag
   Envname = local.env_tags.envname
   CombineText  = "created using Terraform and Environment is ${local.env_tags.envname}"
 }
}
