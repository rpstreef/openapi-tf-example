# -----------------------------------------------------------------------------
# Module: Cognito Identity
# -----------------------------------------------------------------------------
module "cognito" {
  source = "github.com/rpstreef/tf-cognito?ref=v1.1"

  namespace         = var.namespace
  resource_tag_name = var.resource_tag_name
  region            = var.region

  cognito_identity_pool_name     = var.cognito_identity_pool_name
  cognito_identity_pool_provider = var.cognito_identity_pool_provider

  schema_map = [
    {
      name                = "email"
      attribute_data_type = "String"
      mutable             = false
      required            = true
    },
    {
      name                = "phone_number"
      attribute_data_type = "String"
      mutable             = false
      required            = true
    }
  ]
}

# -----------------------------------------------------------------------------
#  Modules: CodePipeline
# -----------------------------------------------------------------------------
module "codepipeline" {
  source = "github.com/rpstreef/terraform-aws-codepipeline-sam?ref=v1.0"

  resource_tag_name = var.resource_tag_name
  namespace         = var.namespace
  region            = var.region

  github_token        = var.github_token
  github_owner        = var.github_owner
  github_repo         = var.github_repo
  poll_source_changes = var.poll_source_changes

  build_image = "aws/codebuild/standard:4.0"

  stack_name = var.stack_name
}

# -----------------------------------------------------------------------------
#  Modules: CloudWatch
# -----------------------------------------------------------------------------

module "cloudwatch_alarms_apigateway" {
  source = "github.com/rpstreef/terraform-aws-cloudwatch-alarms?ref=v1.0"

  namespace         = var.namespace
  region            = var.region
  resource_tag_name = var.resource_tag_name

  create_errorRate_alarm       = false
  create_throttleCount_alarm   = false
  create_canary_alarm          = false
  create_iteratorAge_alarm     = false
  create_deadLetterQueue_alarm = false

  api_name  = var.api_name
  api_stage = var.api_stage
  resources = var.api_resources
}

# -----------------------------------------------------------------------------
#  Modules: Lambda services
# -----------------------------------------------------------------------------
module "identity" {
  source = "../../services/identity"

  resource_tag_name = var.resource_tag_name
  namespace         = var.namespace
  region            = var.region

  cognito_user_pool_arn = module.cognito.cognito_user_pool_arn

  lambda_function_identity_arn = var.lambda_function_identity_arn

  api_gateway_rest_api_id = var.api_gateway_rest_api_id
}

module "user" {
  source = "../../services/user"

  resource_tag_name = var.resource_tag_name
  namespace         = var.namespace
  region            = var.region

  cognito_user_pool_arn = module.cognito.cognito_user_pool_arn

  lambda_function_user_arn         = var.lambda_function_user_arn
  lambda_function_userReceiver_arn = var.lambda_function_userReceiver_arn

  api_gateway_rest_api_id = var.api_gateway_rest_api_id
}
