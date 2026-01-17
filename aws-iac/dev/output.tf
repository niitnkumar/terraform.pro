output "vpc_id" {
	description = "The VPC id created by the module"
	value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
	description = "Public subnet IDs created by the module"
	value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
	description = "Private subnet IDs created by the module"
	value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
	description = "NAT Gateway IDs created by the module"
	value       = module.vpc.nat_gateway_ids
}

