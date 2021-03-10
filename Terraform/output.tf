output "web-demo-url" {
  value = "https://${aws_instance.demo_web_server.0.public_dns}:443"
}
