
module "vpc" {
	source = "../modules/network"

	name      = "${var.name}-${var.environment}"
	region    = var.region
	vpc_cidr  = var.vpc_cidr
	enable_dns_support = var.enable_dns_support
	enable_dns_hostnames = var.enable_dns_hostnames
	public_count = var.public_count
	private_count = var.private_count
	public_subnet_cidrs = var.public_subnet_cidrs
	private_subnet_cidrs = var.private_subnet_cidrs
	az_count = var.az_count
	map_public_ip_on_launch = var.map_public_ip_on_launch  
	common_tags = local.common_tags 
	enable_s3_endpoint = var.enable_s3_endpoint
	
}

module "web_sg" {
	source      = "../modules/web-sg"
	name_prefix = "${var.name}-web"
	vpc_id      = module.vpc.vpc_id
	tags        = var.tags

	ingress_rules = var.web_ingress_rules
	egress_rules  = var.web_egress_rules
}

/*
module "vpc_peering" {
  for_each = var.vpc_peering_configurations
  source   = "../modules/vpc-peering"

  requester_vpc_id         = module.vpc.vpc_id
  accepter_vpc_id         = each.value.peer_vpc_id
  auto_accept            = each.value.auto_accept
  peering_connection_name = each.value.peering_name
  requester_route_table_ids = module.vpc.private_route_table_ids
  accepter_route_table_ids = each.value.peer_route_table_ids
  requester_cidr_block   = var.vpc_cidr
  accepter_cidr_block   = each.value.peer_vpc_cidr
}

*/