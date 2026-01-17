
#vpc configuration
region = "ap-south-1"
name = "tangelo"
vpc_cidr = "10.0.0.0/16"
enable_dns_hostnames = true
enable_dns_support = true
az_count = 2
enable_s3_endpoint = true

#subnet configuration
public_count = 2
private_count = 2
map_public_ip_on_launch = true
availability_zones = [ "ap-south-1a", "ap-south-1b" ]
public_subnet_cidrs = ["10.0.0.0/20", "10.0.16.0/20"]
private_subnet_cidrs = ["10.0.32.0/19", "10.0.64.0/19"]

# Web Security Group rules
web_ingress_rules = [
	{
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow HTTP"
	},
	{
		from_port   = 443
		to_port     = 443
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow HTTPS"
	}
]

web_egress_rules = [
	{
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow all outbound"
	}
]

#common tags
environment = "dev"
owner = "devops"
project = "tangelo"


# VPC Peering Configurations
vpc_peering_configurations = {
  "prod" = {
    peer_vpc_id         = "vpc-xxxxxxxxxxxxx1"  # Replace with your prod VPC ID
    auto_accept         = true
    peering_name       = "tangelo-prod-peer"
    peer_route_table_ids = ["rtb-xxxxxxxxxxxxx1"]  # Replace with your prod VPC route table IDs
    peer_vpc_cidr      = "172.31.0.0/16"  # Replace with your prod VPC CIDR
  },
  "staging" = {
    peer_vpc_id         = "vpc-xxxxxxxxxxxxx2"  # Replace with your staging VPC ID
    auto_accept         = true
    peering_name       = "tangelo-staging-peer"
    peer_route_table_ids = ["rtb-xxxxxxxxxxxxx2"]  # Replace with your staging VPC route table IDs
    peer_vpc_cidr      = "172.32.0.0/16"  # Replace with your staging VPC CIDR
  }
}




