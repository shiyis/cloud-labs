output "private_key" {
  value     = tls_private_key.my_key.private_key_pem
  sensitive = true
}

output "keyname" {
  value = var.keyname
  description = "name of key"
}