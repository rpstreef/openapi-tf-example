profile = "multithreadlabs-dev"

# General
region            = "us-east-1"
namespace         = "dev"
resource_tag_name = "example"

# Cognito
cognito_identity_pool_name     = "users"
cognito_identity_pool_provider = "providers"

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
