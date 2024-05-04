//output "PrivateIP" {
//  description = "Private IP of EC2 instance"
//  value       = aws_instance.my-instance[count.index].private_ip
//}

output "PrivateIP" {
  value = "${formatlist("%v", aws_instance.my-instance.*.private_ip)}"
}

output "private_key" {
  value     = module.keypair.private_key
  sensitive = true
}