# Generate new private key
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}
# Generate a key-pair with above key
resource "aws_key_pair" "deployer" {
  key_name   = "efs-key"
  public_key = tls_private_key.my_key.public_key_openssh
}




# Deafult VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
# Creating a new security group for EC2 instance with ssh and http and EFS inbound rules
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_default_vpc.default.id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "EFS mount target"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# EC2 instance
resource "aws_instance" "web" {
  ami             = "ami-026b57f3c383c2eec"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.ec2_security_group.name]
  tags = {
    Name = "WEB"
  }
}


//# Creating EFS file system
//resource "aws_efs_file_system" "efs" {
//  creation_token = "my-efs"
//  tags = {
//    Name = "MyProduct"
//  }
//}
//# Creating Mount target of EFS
//resource "aws_efs_mount_target" "mount" {
//  file_system_id  = aws_efs_file_system.efs.id
//  subnet_id       = aws_instance.web.subnet_id
//  security_groups = [aws_security_group.ec2_security_group.id]
//}
//# Creating Mount Point for EFS
//resource "null_resource" "configure_nfs" {
//  depends_on = [
//  aws_efs_mount_target.mount]
//  connection {
//    type        = "ssh"
//    user        = "ec2-user"
//    private_key = tls_private_key.my_key.private_key_pem
//    host        = aws_instance.web.public_ip
//  }
//
//  provisioner "remote-exec" {
//    inline = [
//      "mkdir ~/efs-mount-point1",
//      "sudo yum install nfs-utils -y -q ", # Amazon ami has pre installed nfs utils
//      # Mounting Efs
//      "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  ~/efs-mount-point",
//      # Making Mount Permanent
//      "cd ~/efs-mount-point",
//      "sudo chmod go+rw ."
//    ]
//  }
//}
output "private_key" {
  value     = tls_private_key.my_key.private_key_pem
  sensitive = true
}

output "aws_instance_public_ip" {
  value = aws_instance.web.public_ip

}
# terraform output -raw private_key
# terraform output -raw aws_instance_public_ip