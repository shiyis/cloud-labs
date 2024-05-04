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


###### ALB-ASG CONFIG ######

resource "aws_launch_configuration" "terramino" {
  name_prefix     = "learn-terraform-aws-asg-"
  image_id        = var.image_id
  instance_type   = "t2.micro"
  user_data       = file(var.user-data)
  security_groups = [aws_security_group.terramino_instance.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "terramino" {
  name                 = "terramino"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.terramino.name
  vpc_zone_identifier  = tolist([aws_subnet.subnet0.id, aws_subnet.subnet1.id])

  tag {
    key                 = "Name"
    value               = "HashiCorp Learn ASG - Terramino"
    propagate_at_launch = true
  }
}

resource "aws_lb" "terramino" {
  name               = "learn-asg-terramino-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terramino_lb.id]
  subnets            = tolist([aws_subnet.subnet0.id, aws_subnet.subnet1.id])
}

resource "aws_lb_listener" "terramino" {
  load_balancer_arn = aws_lb.terramino.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terramino.arn
  }
}

resource "aws_lb_target_group" "terramino" {
  name     = "learn-asg-terramino"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}


resource "aws_autoscaling_attachment" "terramino" {
  autoscaling_group_name = aws_autoscaling_group.terramino.id
  alb_target_group_arn   = aws_lb_target_group.terramino.arn
}

resource "aws_security_group" "terramino_instance" {
  name = "learn-asg-terramino-instance"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.terramino_lb.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.terramino_lb.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.terramino_lb.id]
  }

  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group" "terramino_lb" {
  name = "learn-asg-terramino-lb"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    /* security_groups = [aws_security_group.terramino_instance.id] */
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id
}


###### EC2 CONFIG ######

### KEY PAIR ###

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name   = "efs-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

### EC2 SECURITY GROUP ###

resource "aws_security_group" "terramino" {
  name   = "learn-ec2-and-rds"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH from VPC"
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

  ingress {
    description = "MySQL port"
    from_port   = 3306
    to_port     = 3306
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
      "mkdir ~/efs-mount-point1",
      "sudo yum install nfs-utils -y -q ", # Amazon ami has pre installed nfs utils
      # Mounting Efs
      "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  ~/efs-mount-point",
      # Making Mount Permanent
      "cd ~/efs-mount-point",
      "sudo chmod go+rw ."
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


###### RDS CONFIG ######



### RDS INSTANCE ###

resource "aws_db_subnet_group" "_" {
  name       = "learn-rds"
  subnet_ids = tolist([aws_subnet.subnet2.id, aws_subnet.subnet3.id])

  tags = {
    Name = "learn rds"
  }
}

data "aws_secretsmanager_secret_version" "MySQL" {
  # Fill in the name you gave to your secret
  secret_id = "MySQL"
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.MySQL.secret_string
  )
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage      = 20
  identifier             = "rds-terraform"
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0.27"
  instance_class         = "db.t2.micro"
  db_name                = "test"
  username               = local.db_creds.username
  password               = local.db_creds.password
  db_subnet_group_name   = aws_db_subnet_group._.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false
  skip_final_snapshot = true


  tags = {
    Name = "RDSServerInstance"
  }
}

### RDS SECURITY GROUP ###

resource "aws_security_group" "rds" {
  name   = "learn-rds"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "MySQL port"
    from_port   = 3306
    to_port     = 3306
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

### RDS OUTPUT ###

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.rds_instance.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.rds_instance.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.rds_instance.username
  sensitive   = true
}