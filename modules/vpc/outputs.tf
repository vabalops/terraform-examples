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
