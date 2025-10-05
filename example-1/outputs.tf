output "load_balancer_dns" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.example_1.dns_name
}