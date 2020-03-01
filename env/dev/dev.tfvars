profile = "multithreadlabs-dev"

# General
region            = "us-east-1"
namespace         = "dev"
resource_tag_name = "example"

# Cognito
cognito_identity_pool_name     = "users"
cognito_identity_pool_provider = "providers"

# Lambda & API endpoint configuration
debug_sample_rate = 0.05

# Identity (login/authentication)
lambda_identity_memory_size = 256
lambda_identity_timeout     = 4
lambda_identity_api_timeout = 4000

# User and Roles
lambda_user_memory_size = 256
lambda_user_timeout     = 4
lambda_user_api_timeout = 4000

# API Gateway
api_throttling_rate_limit  = 5
api_throttling_burst_limit = 10
api_metrics_enabled        = true
api_logging_level          = "ERROR"
xray_tracing_enabled       = true

# Github
# Prompt for github_token, do not store in Source repo
github_owner        = "rpstreef"
github_repo         = "openapi-node-example"
poll_source_changes = "true"

# CloudWatch API Gateway
api_resources = {
  "/identity/authenticate" = "POST",
  "/identity/register"     = "POST",
  "/identity/reset"        = "POST",
  "/identity/verify"       = "POST",
  "/user"                  = "GET"
}
