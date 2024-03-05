output "vpc_id" {
  description = "Main VPC ID"
  value       = aws_vpc.main.id
}

output "private_subnets" {
  description = "List of Private Subnet IDs"
  value       = aws_subnet.private.*.id
}

output "public_subnets" {
  description = "List of Public Subnet IDs"
  value       = aws_subnet.public.*.id
}
