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
# Variables: SNS
# -----------------------------------------------------------------------------
variable "topic_name" {
  description = "Name of the SNS topic"
}

variable "lambda_function_arn" {
  description = "Lambda function ARN that subscribes to this topic"
}
