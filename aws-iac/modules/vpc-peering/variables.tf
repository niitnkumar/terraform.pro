# ---------------------------------------------------------------------------------------------------------------------
# Requester VPC Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "requester_vpc_id" {
    description = "VPC ID of the requesting VPC"
    type        = string
}

variable "requester_route_table_ids" {
    description = "List of route table IDs in the requester VPC"
    type        = list(string)
}

variable "requester_cidr_block" {
    description = "CIDR block of the requester VPC"
    type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Accepter VPC Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "accepter_vpc_id" {
    description = "VPC ID of the accepter VPC"
    type        = string
}

variable "accepter_route_table_ids" {
    description = "List of route table IDs in the accepter VPC"
    type        = list(string)
}

variable "accepter_cidr_block" {
    description = "CIDR block of the accepter VPC"
    type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Peering Connection Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "auto_accept" {
    description = "Automatically accept the peering connection"
    type        = bool
    default     = true
}

variable "peering_connection_name" {
    description = "Name tag for the peering connection"
    type        = string
}