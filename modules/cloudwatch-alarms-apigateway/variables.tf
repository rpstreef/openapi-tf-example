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
# Variables: API Gateway
# -----------------------------------------------------------------------------

variable "api_name" {
  description = "API Gateway Name"
}

variable "api_stage" {
  description = "API Gateway stage"
}

# -----------------------------------------------------------------------------
# Variables: Cloudwatch Alarms Latency
# -----------------------------------------------------------------------------

variable "resources" {
  description = "Methods that have Cloudwatch alarms enabled"
  type        = map
}

variable "latency_threshold_p95" {
  description = "The value against which the specified statistic is compared"
  default     = 1000
}

variable "latency_threshold_p99" {
  description = "The value against which the specified statistic is compared"
  default     = 1000
}

variable "create_latency_alarm" {
  description = "Enable/disable latency alerts"
  type        = bool
  default     = true
}

variable "latency_evaluationPeriods" {
  description = "The number of periods over which data is compared to the specified threshold"
  default     = 5
}

variable "fourRate_threshold" {
  description = "Percentage of errors that will trigger an alert"
  default     = 0.02
  type        = number
}

variable "fourRate_evaluationPeriods" {
  description = "How many periods are evaluated before the alarm is triggered"
  default     = 5
  type        = number
}

variable "fiveRate_threshold" {
  description = "Percentage of errors that will trigger an alert"
  default     = 0.02
  type        = number
}

variable "fiveRate_evaluationPeriods" {
  description = "How many periods are evaluated before the alarm is triggered"
  default     = 5
  type        = number
}
