#Create and bootstrap webserver
resource "aws_instance" "webserver" {
  ami                         = data.aws_ssm_parameter.webserver-ami.value
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.webserver-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.subnet.id
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>My Test Website With Help From Terraform Provisioner</center></h1>' > index.html",
      "sudo mv index.html /var/www/html/",
      "echo '<h1><center>Something wrong here</center></h1>' > error.html"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.p_key.private_key_pem
      host        = self.public_ip
    }
  }
  tags = {
    Name = "webserver"
  }
}
