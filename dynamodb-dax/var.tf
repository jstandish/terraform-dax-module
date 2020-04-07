variable "dynamodb_table_arns" {
  type = list
  description = "List of table ARNs that we are allowed to work with"
}

variable "cluster_name" {
  type = string
}

variable "node_type" {
  type = string
  default = "dax.r4.xlarge"
  description = "The size of a single node in the DAX cluster"
}

variable "replication_factor" {
  type = number
  default = 1
}

variable "subnet_ids" {
    type = list
}

variable "src_security_group_ids" {
    type = list
    default = []
    description = "(Optional) Only allow traffic ingress from the security group."
}

variable "security_group_ingress_cidr_blocks" {
    type = list
    default = []
    description = "(Optional) Only allow traffic ingress from the CIDR blocks."
}

variable "security_group_egress_cidr_blocks" {
    type = list
    default = []
    description = "(Optional) Only allow traffic ingress from the CIDR blocks."
}

variable "vpc_id" {
    type = string
}

variable "tags" {
    type = map
}
