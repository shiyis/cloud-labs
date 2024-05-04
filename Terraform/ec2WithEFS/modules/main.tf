###### VPC CONFIG ######

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-vpc"
  }

}

### ROUTE TABLE DATA ###

data "aws_route_table" "route_table" {
  filter {
    name   = "association.main"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
}

#Create subnet # 1
resource "aws_subnet" "subnet0" {
  availability_zone = element(var.az_names, 0)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
}

#Create subnet # 2
resource "aws_subnet" "subnet1" {
  availability_zone = element(var.az_names, 1)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
}

#Create subnet # 3
resource "aws_subnet" "subnet2" {
  availability_zone = element(var.az_names, 2)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
}

#Create subnet # 4
resource "aws_subnet" "subnet3" {
  availability_zone = element(var.az_names, 3)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
}

###### IGW CONFIG ######

### IGW ###

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

### ROUTE TABLE ###

resource "aws_default_route_table" "internet_route" {
  default_route_table_id = data.aws_route_table.route_table.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Terraform-RouteTable"
  }
}

###### EC2 CONFIG ######

### KEY PAIR ###

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name   = "efs-key-2"
  public_key = tls_private_key.my_key.public_key_openssh
}

### EC2 SECURITY GROUP ###

resource "aws_security_group" "terramino" {
  name   = "learn-ec2-and-rds"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "EFS mount point"
    from_port   = 2049
    to_port     = 2049
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

### EC2 INSTANCE ###

resource "aws_instance" "ec2" {
  ami             = var.image_id
  instance_type   = var.type
  key_name        = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.terramino.id]
  subnet_id = aws_subnet.subnet0.id
  associate_public_ip_address = true

}

###### EFS CONFIG ######

# Creating EFS file system
resource "aws_efs_file_system" "efs" {
  depends_on     = [aws_instance.ec2]
  creation_token = "my-efs"
  tags = {
    Name = "MyProduct"
  }
}

### EFS MOUNT TARGET ###

resource "aws_efs_mount_target" "mount" {
  depends_on      = [aws_efs_file_system.efs]
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_instance.ec2.subnet_id
  security_groups = [aws_security_group.terramino.id]
}

### EFS MOUNT POINT ###

resource "null_resource" "configure_nfs" {
  depends_on = [aws_efs_mount_target.mount]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.my_key.private_key_pem
    host        = aws_instance.ec2.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir ~/efs-mount-point",
      "sudo yum install nfs-utils -y -q ",
      # Mount EFS
      "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  ~/efs-mount-point",
      # Making Mount Permanent
      "cd ~/efs-mount-point",
      "sudo chmod go+rw ~/efs-mount-point"
    ]
  }
}

### EFS OUTPUT ###

output "private_key" {
  value     = tls_private_key.my_key.private_key_pem
  sensitive = true
}

output "aws_instance_public_ip" {
  value = aws_instance.ec2.public_ip
}

