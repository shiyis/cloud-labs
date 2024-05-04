data "aws_ami" "linux_ami" {
  most_recent = true
  owners      = ["amazon"]

filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

output "amiid"{
  value       = data.aws_ami.linux_ami.id
 description = "Instance ID"
}

//
//data "aws_ami" "ubuntu" {
//    most_recent = true
//
//    filter {
//        name   = "name"
//        values = ["ubuntu/images/hvm-ssd/*"]
//    }
//
//    filter {
//        name   = "virtualization-type"
//        values = ["hvm"]
//    }
//}
//
//output "ubentu-ami"{
// value = data.aws_ami.ubuntu.id
// description = "latest Ubuntu ami"
//}
////
////
resource "aws_instance" "my_vm1" {
  ami           = data.aws_ami.linux_ami.id
  instance_type = "t2.micro"


  tags = {
    Name = "My EC2 instance in ${data.aws_region.current.id} and ${data.aws_caller_identity.current.user_id}",
  }
}

output "ec2amiid"{
  value       = aws_instance.my_vm1.ami
 description = "Instance ID"
}

