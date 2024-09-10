variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key for the environment"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "namespace" {
  type        = string
  description = "Namespace for resources"
}

variable "stage" {
  type        = string
  description = "Stage of deployment (e.g., development, staging)"
}

variable "name" {
  type        = string
  description = "Name for the VPC and subnets"
}

variable "default_security_group_deny_all" {
  type        = bool
  description = "Whether to deny all traffic in the default security group"
}

variable "default_route_table_no_routes" {
  type        = bool
  description = "Whether to remove all routes from the default route table"
}

variable "default_network_acl_deny_all" {
  type        = bool
  description = "Whether to deny all traffic in the default network ACL"
}

variable "network_address_usage_metrics_enabled" {
  type        = bool
  description = "Whether to enable network address usage metrics"
}
  type        = string
  default     = ""
  description = "Naming of current project"
}

variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

