variable "profile" {
  description = "AWS Profile used for this deployment"
}

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
  description = "Resource name for billing purposes"
}

# -----------------------------------------------------------------------------
# Variables: Cognito
# -----------------------------------------------------------------------------

variable "cognito_identity_pool_name" {
  description = "Name of the Cognito identity pool"
}

variable "cognito_identity_pool_provider" {
  description = "Name of the Cognito identity pool provider"
}

# -----------------------------------------------------------------------------
# Variables: CodePipeline
# -----------------------------------------------------------------------------
variable "github_token" {
  type        = string
  description = "Github OAuth token"
}

variable "github_owner" {
  type        = string
  description = "Github username"
}

variable "github_repo" {
  type        = string
  description = "Github repository name"
}

variable "poll_source_changes" {
  type        = string
  default     = "false"
  description = "Periodically check the location of your source content and run the pipeline if changes are detected"
}

# -----------------------------------------------------------------------------
# Variables: Lambda
# -----------------------------------------------------------------------------
variable "lambda_function_userReceiver_arn" {
  description = "Lambda function User ARN"
}

variable "lambda_function_user_arn" {
  description = "Lambda function User Receiver ARN"
}

variable "lambda_function_identity_arn" {
  description = "Lambda function Identity ARN"
}

# -----------------------------------------------------------------------------
# Variables: API Gateway
# -----------------------------------------------------------------------------
variable "api_gateway_rest_api_id" {
  description = "API Gateway ID"
}

variable "api_resources" {
  description = "API Resources that require Cloudwatch monitoring"
}

variable "api_name" {
  description = "API Gateway Name"
  type        = string
}

variable "api_stage" {
  description = "API Gateway stage"
  type        = string
}