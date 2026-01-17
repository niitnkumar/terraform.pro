# ---------------------------------------------------------------------------------------------------------------------
# General Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
    description = "Name prefix for all VPC resources"
    type        = string
    default     = "example-vpc"
}

variable "region" {
    description = "Region where the VPC will be created. Module defaults to Mumbai (ap-south-1). Ensure provider is configured to use the same region or pass provider from root."
    type        = string
    default     = "ap-south-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "vpc_cidr" {
    description = "CIDR block for the VPC"
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

variable "domain" {
    description = "selection of domain for eip"
    type        = string
    default     = "vpc"
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
    description = "Number of availability zones to distribute subnets across. Defaults to 2 (will use first 2 available AZs)."
    type        = number
    default     = 2
}

variable "public_subnet_cidrs" {
    description = "Optional explicit CIDR list for public subnets. If empty, subnets are derived from vpc_cidr (/24 subnets)."
    type        = list(string)
    default     = []
}

variable "private_subnet_cidrs" {
    description = "Optional explicit CIDR list for private subnets. If empty, subnets are derived from vpc_cidr (/24 subnets)."
    type        = list(string)
    default     = []
}

variable "availability_zones" {
    description = "Optional list of availability zones to use. If empty, module will use first N AZs in the region, where N is az_count."
    type        = list(string)
    default     = []
}

variable "map_public_ip_on_launch" {
    description = "Boolean to control if public subnets should map public IPs on launch"
    type        = bool
    default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# NACL Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "public_nacl_protocol" {
    description = "Protocol for public subnet NACL rules. Use '-1' for all."
    type        = string
    default     = "-1"
}

variable "public_nacl_from_port" {
    description = "From port for public subnet NACL rules."
    type        = number
    default     = 0
}

variable "public_nacl_to_port" {
    description = "To port for public subnet NACL rules."
    type        = number
    default     = 0
}

variable "private_nacl_protocol" {
    description = "Protocol for private subnet NACL rules. Use '-1' for all."
    type        = string
    default     = "-1"
}

variable "private_nacl_from_port" {
    description = "From port for private subnet NACL rules."
    type        = number
    default     = 0
}

variable "private_nacl_to_port" {
    description = "To port for private subnet NACL rules."
    type        = number
    default     = 0
}

variable "public_nacl_ingress_cidr" {
    description = "CIDR block for public subnet NACL ingress rule."
    type        = string
    default     = "0.0.0.0/0"
}

variable "public_nacl_egress_cidr" {
    description = "CIDR block for public subnet NACL egress rule."
    type        = string
    default     = "0.0.0.0/0"
}

variable "private_nacl_ingress_cidr" {
    description = "CIDR block for private subnet NACL ingress rule."
    type        = string
    default     = "0.0.0.0/0"
}

variable "private_nacl_egress_cidr" {
    description = "CIDR block for private subnet NACL egress rule."
    type        = string
    default     = "0.0.0.0/0"
}

variable "nacl_rule_no" {
    description = "Rule number for NACL rules."
    type        = number
    default     = 100
}

variable "nacl_action" {
    description = "Action for NACL rules (allow or deny)."
    type        = string
    default     = "allow"
}

# ---------------------------------------------------------------------------------------------------------------------
# Tag Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
    description = "Additional tags to apply to resources"
    type        = map(string)
    default     = {}
}

variable "common_tags" {
    description = "Standard tags for all resources"
    type        = map(string)
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