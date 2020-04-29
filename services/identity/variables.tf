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

# -----------------------------------------------------------------------------
# Variables: Lambda
# -----------------------------------------------------------------------------
variable "lambda_function_identity_arn" {
  description = "Lambda function Identity ARN"
}

# -----------------------------------------------------------------------------
# Variables: API Gateway
# -----------------------------------------------------------------------------
variable "api_gateway_rest_api_id" {
  description = "API Gateway ID"
}