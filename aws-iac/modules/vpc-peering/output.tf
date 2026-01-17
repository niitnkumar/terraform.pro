output "vpc_peering_connection_id" {
  description = "The ID of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.peer.id
}

output "vpc_peering_connection_status" {
  description = "The status of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.peer.accept_status
}