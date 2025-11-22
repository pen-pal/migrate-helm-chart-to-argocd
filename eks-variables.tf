variable "vpc_id" {
  type        = string
  description = "current vpc_id, in case we want to re-use stuffs, improve later"
  default     = ""
}
variable "vpc_private_subnet_ids" {
  type        = list(string)
  description = "current vpc_subnets, in case we want to re-use stuffs, improve later"
  default     = []
}
variable "vpc_public_subnet_ids" {
  type        = list(string)
  description = "current public vpc_subnets, improve later"
  default     = []
}
variable "vpc_cidr_number" {
  description = "Number used to define the VPC CIDR, EG: 10.xx.0.0/16"
  type        = string
  default     = ""
}
variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.21`)"
  type        = string
  default     = "1.30"
}
variable "cluster_security_group_description" {
  description = "Description of the cluster security group created"
  type        = string
  default     = "EKS cluster security group."
}
variable "cluster_security_group_name" {
  description = "Name to use on cluster security group created"
  type        = string
  default     = null
}
variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}
variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}
variable "manage_aws_auth_configmap" {
  description = "Determines whether to manage the aws-auth configmap"
  type        = bool
  default     = true
}
variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}
variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}
variable "create_cloudwatch_log_group" {
  description = "Determines whether a log group is created by this module for the cluster logs. If not, AWS will automatically create one if logging is enabled"
  type        = bool
  default     = true
}
variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 90 days"
  type        = number
  default     = 3

}
################################################################################
# EKS Managed Node Group
################################################################################
variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default     = {}
}
variable "eks_managed_node_group_defaults" {
  description = "Map of EKS managed node group default configurations"
  type        = any
  default     = {}
}
################################################################################
# Self Managed Node Group
################################################################################
variable "self_managed_node_groups" {
  description = "Map of Self managed node group definitions to create"
  type        = any
  default     = {}
}
variable "self_managed_node_group_defaults" {
  description = "Map of Self managed node group default configurations"
  type        = any
  default     = {}
}
################################################################################
variable "instance_types" {
  description = "Set of instance types associated with the EKS Node Group. Defaults to `[\"t3.medium\"]`"
  type        = list(string)
  default     = ["t3a.medium"]
}
variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}
################################################################################
variable "create_ondemand_nodes" {
  default = false
}
variable "ondemand_instance_types" {
  description = "Set of instance types associated with the EKS Node Group. Defaults to `[\"t3.medium\"]`"
  type        = list(string)
  default     = ["t3a.medium"]
}
variable "ondemand_min_size" {
  description = "Minimum number of instances/nodes"
  type        = number
  default     = 1
}
variable "ondemand_max_size" {
  description = "Maximum number of instances/nodes"
  type        = number
  default     = 3
}
variable "ondemand_desired_size" {
  description = "Desired number of instances/nodes"
  type        = number
  default     = 1
}
variable "ondemand_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}
variable "ondemand_ami_type" {
  description = "AMI To use"
  type        = string
  default     = "BOTTLEROCKET_ARM_64_FIPS"
}
