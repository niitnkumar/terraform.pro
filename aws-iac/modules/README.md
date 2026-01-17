# Terraform Modules (repository-local)

This folder contains reusable Terraform modules used by the environment-level configurations under `dev/`.

Purpose
- Keep reusable infrastructure code (VPC, Security Groups, VPC Peering) in one place.
- Provide a stable interface (inputs/outputs) so environment configs can be simple and consistent.

Modules in this repository

- `modules/network`
  - Purpose: Create a VPC with public and private subnets, route tables, NACLs and optionally VPC endpoints.
  - Important outputs (examples): `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `private_route_table_ids`, `public_route_table_ids`.
  - Typical inputs: `name`, `vpc_cidr`, `public_count`, `private_count`, `public_subnet_cidrs`, `private_subnet_cidrs`, `enable_dns_hostnames`, `enable_dns_support`, `map_public_ip_on_launch`, `availability_zones`, `tags`.

- `modules/web-sg`
  - Purpose: Create a web-tier Security Group with configurable ingress/egress rules.
  - Important outputs: usually `security_group_id` (module-specific name may vary).
  - Typical inputs: `name_prefix`, `vpc_id`, `ingress_rules`, `egress_rules`, `tags`.

- `modules/vpc-peering`
  - Purpose: Create a VPC peering connection and add routes to route tables on both sides.
  - Important outputs: `vpc_peering_connection_id`, `vpc_peering_connection_status`.
  - Typical inputs: `requester_vpc_id`, `requester_route_table_ids`, `requester_cidr_block`, `accepter_vpc_id`, `accepter_route_table_ids`, `accepter_cidr_block`, `auto_accept`, `peering_connection_name`.

How to call modules 

- Network module (example):

```hcl
module "vpc" {
  source = "../modules/network"
  name   = "${var.name}-${var.environment}"
  region = var.region

  vpc_cidr                = var.vpc_cidr
  public_count            = var.public_count
  private_count           = var.private_count
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_subnet_cidrs    = var.private_subnet_cidrs
  az_count                = var.az_count
  enable_dns_support      = var.enable_dns_support
  enable_dns_hostnames    = var.enable_dns_hostnames
  map_public_ip_on_launch = var.map_public_ip_on_launch
  common_tags             = local.common_tags
}
```

- Web SG module (example):

```hcl
module "web_sg" {
  source      = "../modules/web-sg"
  name_prefix = "${var.name}-web"
  vpc_id      = module.vpc.vpc_id
  tags        = var.tags

  ingress_rules = var.web_ingress_rules
  egress_rules  = var.web_egress_rules
}
```

- VPC peering module (example using for_each):

```hcl
module "vpc_peering" {
  for_each = var.vpc_peering_configurations
  source   = "../modules/vpc-peering"

  requester_vpc_id         = module.vpc.vpc_id
  requester_route_table_ids = module.vpc.private_route_table_ids
  requester_cidr_block     = var.vpc_cidr

  accepter_vpc_id          = each.value.peer_vpc_id
  accepter_route_table_ids = each.value.peer_route_table_ids
  accepter_cidr_block      = each.value.peer_vpc_cidr

  auto_accept              = each.value.auto_accept
  peering_connection_name  = each.value.peering_name
}
```

Inputs and outputs
- Each module exposes variables via `variables.tf` and outputs via `output.tf` inside its folder. Always check a module's `variables.tf` to see required values and `output.tf` to discover what it exports.

Conventions and best practices used here
- Module paths are relative from environment folders: use `../modules/<module-name>` when calling from `dev/`.
- Keep variable names descriptive and group them logically in `variables.tf`.
- Use `for_each` on module calls to create multiple instances of the same module (e.g., multiple peering connections).
- Keep secrets out of checked-in `.tfvars`; use environment variables or secret management solutions where needed.

Troubleshooting
- Unreadable module directory / path errors:
  - Verify the path and case: the repository uses the `modules/` folder (lowercase) next to `dev/`.
  - Example correct path from `dev/`: `../modules/network`.

- Missing variable or type errors:
  - Confirm the variable exists in the module's `variables.tf` and the type matches what you pass from the environment.

- Peering behavior: if `auto_accept = false`, the accepter side must accept the connection manually or via automation in the other account/region.

Maintenance
- When updating module interfaces (adding/removing variables or outputs), update environment-level `variables.tf` and `terraform.tfvars` accordingly and run `terraform plan`.

Contact / Ownership
- If you need help extending a module or adding a new one, open an issue or contact the infrastructure owner/team listed in the repo metadata.

---

Generated: October 9, 2025
