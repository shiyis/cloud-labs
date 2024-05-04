# Need to grab info from the module
# Otherwise the variables do not get referenced properly

/* output "lb_endpoint" {
  value = "https://${aws_lb.terramino.dns_name}"
}

output "application_endpoint" {
  value = "https://${aws_lb.terramino.dns_name}/index.php"
}

output "asg_name" {
  value = aws_autoscaling_group.terramino.name
} */