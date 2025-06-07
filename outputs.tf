output "wordpress_public_ip" {
  description = "Public IP of the WordPress server"
  value       = aws_instance.wordpress.public_ip
}
