resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  auto_accept   = var.auto_accept

  tags = {
    Name = var.peering_connection_name
  }
}

resource "aws_route" "requester_routes" {
  count                     = length(var.requester_route_table_ids)
  route_table_id            = var.requester_route_table_ids[count.index]
  destination_cidr_block    = var.accepter_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "accepter_routes" {
  count                     = length(var.accepter_route_table_ids)
  route_table_id            = var.accepter_route_table_ids[count.index]
  destination_cidr_block    = var.requester_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}