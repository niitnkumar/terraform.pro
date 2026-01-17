# Development Environment — Terraform (dev)

This directory contains the Terraform configuration for the development environment of the project.

Overview
- Purpose: Provision a VPC, subnets, networking constructs, web security group(s), and optional VPC peering connections used by the development environment.
- Location: This configuration references local modules in `../modules/` (relative to this folder).

Contents
- `backend.tf` — remote backend settings (if configured)
- `provider.tf` — provider configuration
- `network.tf` — module calls for network, security group, and peering
- `variables.tf` — root-level variables for this environment
- `terraform.tfvars` — environment-specific values (do not commit secrets)
- `local.tf` — local values and computed tags
- `output.tf` — outputs from this environment

Quick start

1. Initialize the working directory:

```bash
cd aws-iac/dev
terraform init
```

2. Validate and create a plan:

```bash
terraform validate
terraform plan -out plan.tfplan
```

3. Apply the plan:

```bash
terraform apply "plan.tfplan"
```

Module paths

This environment expects modules under `../modules/` (note the directory name and lowercase). Example module sources in `network.tf`:

```hcl
module "vpc" {
  source = "../modules/network"
  ...
}

module "web_sg" {
  source = "../modules/web-sg"
  ...
}

module "vpc_peering" {
  source = "../modules/vpc-peering"
  for_each = var.vpc_peering_configurations
  ...
}
```

Variables

- Configure `terraform.tfvars` in this folder or pass variables via CLI. Key variables include:
  - `region` — AWS region (e.g., `ap-south-1`)
  - `name` — resource name prefix
  - `vpc_cidr` — CIDR block for the VPC
  - `public_subnet_cidrs`, `private_subnet_cidrs` — lists of subnet CIDRs
  - `web_ingress_rules`, `web_egress_rules` — security group rules
  - `vpc_peering_configurations` — a map of peering entries to create

Example multi-peering map (in `terraform.tfvars`):

```hcl
vpc_peering_configurations = {
  "prod" = {
    peer_vpc_id           = "vpc-01234567"
    auto_accept           = true
    peering_name          = "prod-peer"
    peer_route_table_ids  = ["rtb-01234567"]
    peer_vpc_cidr         = "172.31.0.0/16"
  }
}
```

Outputs

Outputs from this environment are defined in `output.tf`. Typical outputs:
- `vpc_id`
- `public_subnet_ids`
- `private_subnet_ids`
- `vpc_peering_connection_ids` (if peering enabled)

Troubleshooting

- Unreadable module directory / path errors:
  - Ensure module source paths are `../modules/<name>` and match the exact folder names (lowercase `modules`).

- Variable errors:
  - Ensure required variables are declared in `variables.tf` and provided in `terraform.tfvars` or via other means.

- Peering issues:
  - If `auto_accept = false`, you must accept the peering from the accepter side.
  - Ensure route table IDs correspond to the correct VPC.

Security

- Do not store secrets directly in `terraform.tfvars` in the repository. Use environment variables, a secrets manager, or CI pipeline secrets.

Notes

- This README is a high-level guide. For module-specific inputs/outputs, check the module folders in `../modules/`.

Generated on: October 9, 2025
