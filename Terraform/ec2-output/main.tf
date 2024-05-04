resource "aws_instance" "my_vm" {
 ami           = var.ami
 instance_type = var.instance_type

 tags = {
   Name = var.name_tag,
 }
}

output "instance_id" {
 value       = aws_instance.my_vm.id
 description = "Instance ID"
}

output "instance_ip" {
 value       = aws_instance.my_vm.associate_public_ip_address
 description = "Instance ID"
}

output "instance_subnet" {
 value       = aws_instance.my_vm.subnet_id
 description = "Instance ID"
}

output "instance_ami" {
 value       = aws_instance.my_vm.ami
 description = "Instance ID"
}
#terraform output -raw instance_id