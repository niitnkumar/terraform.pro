# ---------------------------------------------------------------------------------------------------------------------
# General Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
    description = "AWS region to deploy into"
    type        = string
    default     = "ap-south-1"
}

variable "name" {
    description = "Name prefix for resources"
    type        = string
    default     = "my-mumbai-vpc"
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "vpc_cidr" {
    description = "VPC CIDR block"
    type        = string
    default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    description = "Enable DNS hostnames in the VPC"
    type        = bool
    default     = true
}

variable "enable_dns_support" {
    description = "Enable DNS support in the VPC"
    type        = bool
    default     = true
}

variable "enable_s3_endpoint" {
    description = "Whether to create a VPC endpoint for S3."
    type        = bool
    default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Subnet Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "public_count" {
    description = "Number of public subnets to create"
    type        = number
    default     = 2
}

variable "private_count" {
    description = "Number of private subnets to create"
    type        = number
    default     = 2
}

variable "az_count" {
    description = "Number of AZs to use for subnet distribution"
    type        = number
    default     = 2
}

variable "public_subnet_cidrs" {
    description = "Optional list of CIDR blocks for public subnets. If empty, module will derive CIDRs automatically. Length should match public_count when provided."
    type        = list(string)
    default     = []
}

variable "private_subnet_cidrs" {
    description = "Optional list of CIDR blocks for private subnets. If empty, module will derive CIDRs automatically. Length should match private_count when provided."
    type        = list(string)
    default     = []
}

variable "map_public_ip_on_launch" {
    description = "Boolean to control if public subnets should map public IPs on launch"
    type        = bool
    default     = true
}

variable "availability_zones" {
    description = "Optional list of availability zones to use. If empty, module will use first N AZs in the region, where N is az_count."
    type        = list(string)
    default     = []
}


# ---------------------------------------------------------------------------------------------------------------------
# VPC Peering Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "vpc_peering_configurations" {
    description = "Map of VPC peering configurations"
    type = map(object({
        peer_vpc_id           = string
        auto_accept           = bool
        peering_name         = string
        peer_route_table_ids = list(string)
        peer_vpc_cidr        = string
    }))
    default = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# Tag Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
    description = "Map of tags to apply to resources"
    type        = map(string)
    default     = {}
}

variable "environment" {
    description = "Environment tag value (e.g., dev, staging, prod)"
    type        = string
    default     = "dev"
}

variable "owner" {
    description = "Owner tag value (person or team)"
    type        = string
    default     = ""
}

variable "project" {
    description = "Project tag value"
    type        = string
    default     = ""
}

