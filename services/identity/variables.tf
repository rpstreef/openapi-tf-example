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
# Variables: Cognito
# -----------------------------------------------------------------------------

variable "cognito_user_pool_arn" {
  description = "Cognito user pool ARN"
}