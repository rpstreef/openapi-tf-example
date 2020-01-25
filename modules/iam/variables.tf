# -----------------------------------------------------------------------------
# Variables: General
# -----------------------------------------------------------------------------

variable "namespace" {
  description = "AWS resource namespace/prefix"
}

variable "region" {
  description = "AWS region"
}

variable "resource_tag_name" {
  description = "Resource tag name for cost tracking"
}
# -----------------------------------------------------------------------------
# Variables: IAM
# -----------------------------------------------------------------------------

variable "template" {
  description = "JSON template describing the permissions"
}

variable "role_name" {
  description = "Name of the role"
}

variable "policy_name" {
  description = "Name of the policy"
}

variable "policy_attachment_name" {
  description = "Name of the policy attachment document"
  default = "attachment"
}

variable "role_vars" {
  description = "Variables within the JSON template to be included"
  type        = map(string)
}

variable "assume_role_policy" {
  description = "Assume role policy JSON"
}