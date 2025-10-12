output "public_subnet_cidrs" {
  description = "Map of public subnet names to their CIDR blocks"
  value = {
    for s in aws_subnet.public :
    lookup(s.tags, "Name", "") => s.cidr_block
  }
}

output "private_subnet_cidrs" {
  description = "Map of private subnet names to their CIDR blocks"
  value = {
    for s in aws_subnet.private :
    lookup(s.tags, "Name", "") => s.cidr_block
  }
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "vpc_id" { 
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}