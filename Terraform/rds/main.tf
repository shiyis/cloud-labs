### VPC

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "main-vpc"
  cidr = "10.0.0.0/16"

  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

### RDS

resource "aws_db_subnet_group" "_" {
  name       = "learn-rds"
  subnet_ids = module.vpc.public_subnets

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

  publicly_accessible = true
  skip_final_snapshot = true


  tags = {
    Name = "RDSServerInstance"
  }
}

### SG

resource "aws_security_group" "rds" {
  name = "learn-rds"
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
  }

  ingress {
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

  vpc_id = module.vpc.vpc_id
}

### OUTPUTS

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