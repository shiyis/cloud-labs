output "subnet_id" {
  value = aws_subnet.is.id
}

output "ami_id" {
  value = data.aws_ssm_parameter.sparta.value
} 