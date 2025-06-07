resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Allow HTTP and SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Outbound
  }
}

resource "aws_instance" "wordpress" {
  ami                         = "ami-0fc32db49bc3bfbb1"  # ✅ Amazon Linux 2 in eu-west-2
  instance_type               = var.instance_type
  key_name =                    "ubuntu-2025"

  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]
  associate_public_ip_address = true
  user_data                   = file("cloud-init.yaml")

  tags = {
    Name = "terraform-wordpress-instance"
  }
}
