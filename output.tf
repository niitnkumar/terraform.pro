output "vpc_id" {
    value = module.vpc.vpc_id
  
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
  
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
  
}

output "db_subnet_id" {
  value = module.vpc.db_subnet_id
  
}