resource "aws_instance" "my_vm1" {
  ami           = "ami-026b57f3c383c2eec"
  instance_type = "t2.micro"

  tags = {
    Name = "My EC2 instance with update",
  }
}