# AWS VPC Network Module

This Terraform module creates a complete AWS VPC network infrastructure with public and private subnets, NAT Gateway, Internet Gateway, route tables, Network ACLs, and an optional S3 VPC endpoint.

## Features

- VPC with DNS support and hostnames
- Public and private subnets across multiple Availability Zones
- Internet Gateway for public subnet access
- NAT Gateway for private subnet internet access
- Network ACLs for subnet-level security
- S3 VPC Endpoint for private S3 access
- Configurable CIDR blocks and subnet counts
- Automatic AZ distribution
- Consistent tagging

## Usage

```hcl
module "vpc" {
  source = "./Modules/Network"

  name                    = "my-vpc"
  environment            = "dev"
  region                 = "ap-south-1"
  vpc_cidr               = "10.0.0.0/16"
  enable_dns_support     = true
  enable_dns_hostnames   = true
  public_count           = 2
  private_count          = 2
  public_subnet_cidrs    = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnet_cidrs   = ["10.0.32.0/19", "10.0.64.0/19"]
  az_count               = 2
  map_public_ip_on_launch = true
  enable_s3_endpoint     = true
  
  common_tags = {
    Environment = "dev"
    Project     = "example"
    Owner       = "team"
  }
}
```

## Requirements

- AWS Provider >= 4.0
- Terraform >= 1.0.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix for all VPC resources | `string` | n/a | yes |
| region | AWS region | `string` | `"ap-south-1"` | no |
| vpc_cidr | CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |
| enable_dns_support | Enable DNS support in VPC | `bool` | `true` | no |
| enable_dns_hostnames | Enable DNS hostnames in VPC | `bool` | `true` | no |
| public_count | Number of public subnets | `number` | `2` | no |
| private_count | Number of private subnets | `number` | `2` | no |
| public_subnet_cidrs | List of public subnet CIDR blocks | `list(string)` | `[]` | no |
| private_subnet_cidrs | List of private subnet CIDR blocks | `list(string)` | `[]` | no |
| az_count | Number of AZs to use | `number` | `2` | no |
| map_public_ip_on_launch | Auto-assign public IPs on launch | `bool` | `true` | no |
| enable_s3_endpoint | Enable S3 VPC Endpoint | `bool` | `true` | no |
| common_tags | Common tags for all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| nat_gateway_ids | List of NAT Gateway IDs |

## Network Architecture

```plaintext
                                  Internet
                                     │
                                     │
                              Internet Gateway
                                     │
                                     │
                            ┌───────────────────┐
                            │       VPC         │
                            │                   │
              ┌─────────────┼─────────────┐    │
              │             │             │    │
         Public Subnet  Public Subnet     │    │
              │             │             │    │
              │             │             │    │
         NAT Gateway        │             │    │
              │             │             │    │
              │             │             │    │
       Private Subnet  Private Subnet     │    │
              │             │             │    │
              └─────────────┼─────────────┘    │
                            │    │             │
                            └────┼─────────────┘
                                 │
                            S3 Endpoint
```

## Security

The module includes:
- Network ACLs for both public and private subnets
- Configurable ingress/egress rules
- Security best practices for network isolation

## Notes

- The NAT Gateway is placed in the first public subnet
- Private subnets route through the NAT Gateway
- Public subnets route through the Internet Gateway
- S3 endpoint is optional and can be enabled/disabled

## Contributing

Please feel free to submit issues and pull requests.

## License

This module is licensed under the MIT License.