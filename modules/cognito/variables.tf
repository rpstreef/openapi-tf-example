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
# Variables: Cognito & S3
# -----------------------------------------------------------------------------

variable "cognito_identity_pool_name" {
  description = "Cognito identity pool name"
}

variable "cognito_identity_pool_provider" {
  description = "Cognito identity pool provider"
}

variable "alias_attributes" {
  type = list(string)
  default = ["email"]
  description = "(Optional) Attributes supported as an alias for this user pool. Possible values: phone_number, email, or preferred_username. Conflicts with username_attributes. "
}

variable "auto_verified_attributes" {
  type = list
  default = ["email"]
  description = "(Optional) The attributes to be auto-verified. Possible values: email, phone_number. "
}

variable "schema_map" {
  type = list(object({
    name                = string
    attribute_data_type = string
    mutable             = bool
    required            = bool
  }))
  default = []
  description = "Creates 1 or more Schema blocks"
}