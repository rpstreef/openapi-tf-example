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

# API Gateway
api_gateway_rest_api_id = "9qzcnpzu0m"
api_name                = "openapi-example"
api_stage               = "dev"
api_resources = {
  "/identity/authenticate" = "POST",
  "/identity/register"     = "POST",
  "/identity/reset"        = "POST",
  "/identity/verify"       = "POST",
  "/user"                  = "GET"
}

#Lambda
lambda_function_user_arn         = "arn:aws:lambda:us-east-1:921906086636:function:dev-example-user"
lambda_function_userReceiver_arn = "arn:aws:lambda:us-east-1:921906086636:function:dev-example-user-receiver"
lambda_function_identity_arn     = "arn:aws:lambda:us-east-1:921906086636:function:dev-example-identity"
