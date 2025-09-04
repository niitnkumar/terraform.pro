output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.demo_vpc.id
  
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.demo_public_subnet.id
  
}  

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [aws_subnet.demo_private_subnet_1.id, aws_subnet.demo_private_subnet_2.id]
  
}

output "db_subnet_id" {
  description = "The ID of the database subnet"
  value       = aws_subnet.demo_db_subnet.id
  
}