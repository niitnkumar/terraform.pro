# AWS VPC Peering Module

This Terraform module establishes VPC peering connections between two VPCs in AWS, enabling direct private network connectivity between them.

## Features

- Creates VPC peering connection between two VPCs
- Configurable auto-accept for peering requests
- Automatic route table updates for both VPCs
- Support for cross-region peering (when auto_accept = false)
- Flexible route table configuration
- Consistent tagging

## Architecture

```plaintext
┌─────────────┐                          ┌─────────────┐
│             │                          │             │
│  VPC A      │      VPC Peering        │  VPC B      │
│ (Requester) │◄────── Connection ──────►│ (Accepter)  │
│             │                          │             │
└─────────┬───┘                          └───┬─────────┘
          │                                  │
    ┌─────┴─────┐                    ┌──────┴────┐
    │           │                    │           │
    │Route Table│                    │Route Table│
    │   Entry   │                    │   Entry   │
    │           │                    │           │
    └───────────┘                    └───────────┘
```

## Usage

```hcl
module "vpc_peering" {
  source = "./Modules/VPCPeering"

  name = "prod-to-dev"
  
  # Requester VPC details
  vpc_id                    = "vpc-1234567890"
  vpc_cidr                  = "10.0.0.0/16"
  requester_route_table_ids = ["rtb-12345", "rtb-67890"]
  
  # Accepter VPC details
  peer_vpc_id              = "vpc-0987654321"
  peer_vpc_cidr            = "172.16.0.0/16"
  accepter_route_table_ids = ["rtb-abcde", "rtb-fghij"]
  
  # Configuration
  auto_accept = true
  
  tags = {
    Environment = "production"
    Project     = "example"
  }
}
```

## Requirements

- AWS Provider >= 4.0
- Terraform >= 1.0.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix for the peering connection | `string` | n/a | yes |
| vpc_id | ID of the requester VPC | `string` | n/a | yes |
| peer_vpc_id | ID of the accepter VPC | `string` | n/a | yes |
| vpc_cidr | CIDR block of the requester VPC | `string` | n/a | yes |
| peer_vpc_cidr | CIDR block of the accepter VPC | `string` | n/a | yes |
| auto_accept | Whether to automatically accept the peering connection | `bool` | `true` | no |
| requester_route_table_ids | List of route table IDs in the requester VPC | `list(string)` | n/a | yes |
| accepter_route_table_ids | List of route table IDs in the accepter VPC | `list(string)` | `[]` | no |
| tags | Tags to apply to the peering connection | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| peering_connection_id | The ID of the VPC Peering Connection |
| peering_connection_status | The status of the VPC Peering Connection |

## Important Notes

1. **Cross-Region Peering**:
   - Set `auto_accept = false` for cross-region peering
   - Manual acceptance may be required in the accepter region
   - Additional provider configuration needed for cross-region setup

2. **Route Tables**:
   - Routes are automatically added to specified route tables
   - Ensure proper CIDR planning to avoid overlapping ranges
   - Both VPCs must have non-overlapping CIDR blocks

3. **Security**:
   - Review and adjust Security Groups in both VPCs
   - Consider network security implications of VPC peering
   - Remember that transitive peering is not supported

4. **Limitations**:
   - No transitive peering (A ←→ B ←→ C doesn't mean A ←→ C)
   - IPv6 is not supported for VPC peering connections
   - VPCs must have distinct, non-overlapping CIDR blocks

## Best Practices

1. Use meaningful naming conventions
2. Document CIDR ranges carefully
3. Maintain clear tagging strategy
4. Review routes and security groups
5. Plan for non-overlapping IP ranges
6. Consider using resource access manager (RAM) for cross-account peering

## Example with Multiple Route Tables

```hcl
module "vpc_peering" {
  source = "./Modules/VPCPeering"

  name = "prod-to-dev"
  
  vpc_id    = module.vpc_prod.vpc_id
  vpc_cidr  = module.vpc_prod.vpc_cidr
  
  # Multiple route tables for different subnet tiers
  requester_route_table_ids = [
    module.vpc_prod.private_route_table_id,
    module.vpc_prod.database_route_table_id
  ]
  
  peer_vpc_id   = module.vpc_dev.vpc_id
  peer_vpc_cidr = module.vpc_dev.vpc_cidr
  
  accepter_route_table_ids = [
    module.vpc_dev.private_route_table_id,
    module.vpc_dev.public_route_table_id
  ]
  
  auto_accept = true
  
  tags = {
    Environment = "production"
    Peer        = "development"
  }
}
```

## Contributing

Feel free to submit issues and pull requests for additional features or improvements.

## License

This module is licensed under the MIT License.