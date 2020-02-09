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
# Variables: Lambda
# -----------------------------------------------------------------------------
variable "lambda_layer_arn" {
  description = "Lambda layer ARN shared code"
}

variable "lambda_zip_name" {
  description = "Name of the Lambda source code ZIP file"
}

variable "lambda_timeout" {
  description = "Timeout in seconds"
}

variable "lambda_memory_size" {
  description = "Allocated memory (and indirectly CPU power)"
}

variable "dist_path" {
  description = "Path where the ZIP file is located relative to the service"
}

variable "debug_sample_rate" {
  description = "Productive use, how many percentage of logs will be set to Debug"
  type        = number
}

# -----------------------------------------------------------------------------
# Variables: API Gateway
# -----------------------------------------------------------------------------

variable "api_gateway_deployment_execution_arn" {
  description = "API Gateway deployment execution ARN"
}

variable "api_gateway_rest_api_id" {
  description = "API Gateway REST API identifier"
}

# -----------------------------------------------------------------------------
# Variables: Cognito
# -----------------------------------------------------------------------------

variable "cognito_user_pool_arn" {
  description = "Cognito user pool ARN"
}

variable "cognito_user_pool_id" {
  
}

variable "cognito_user_pool_client_id" {
  
}