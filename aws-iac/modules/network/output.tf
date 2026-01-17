output "vpc_id" {
	description = "ID of the VPC created by the module"
	value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
	description = "List of public subnet IDs"
	value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
	description = "List of private subnet IDs"
	value       = aws_subnet.private[*].id
}

output "nat_gateway_ids" {
	description = "List of NAT Gateway IDs (single shared NAT)"
	value       = [aws_nat_gateway.nat.id]
}

