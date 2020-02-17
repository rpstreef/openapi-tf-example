locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"

  api_name = "example"

  dist_file_path = "./dist"

  lambda_zip_name = "dist-example.zip"

  lambda_layer_name        = "example-lambda-layer"
  lambda_layer_zip_name    = "dist-layer.zip"
  lambda_layer_description = "Dependencies to run all Lambda's in the example API"
}

# -----------------------------------------------------------------------------
# Cognito Identity
# -----------------------------------------------------------------------------
module "cognito" {
  source = "github.com/rpstreef/tf-cognito?ref=v1.0"

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
# Lambda Layer
# -----------------------------------------------------------------------------
module "lambda-layer" {
  source = "../../modules/lambda-layer"

  resource_tag_name = var.resource_tag_name
  namespace         = var.namespace
  region            = var.region

  name           = local.lambda_layer_name
  zip_name       = local.lambda_layer_zip_name
  description    = local.lambda_layer_description
  dist_file_path = local.dist_file_path
}

# -----------------------------------------------------------------------------
# API Gateway
# -----------------------------------------------------------------------------
module "apigateway" {
  source            = "github.com/rpstreef/tf-apigateway?ref=v1.2"
  resource_tag_name = var.resource_tag_name
  namespace         = var.namespace
  region            = var.region

  api_name                   = local.api_name
  api_throttling_rate_limit  = var.api_throttling_rate_limit
  api_throttling_burst_limit = var.api_throttling_burst_limit
  api_metrics_enabled        = var.api_metrics_enabled
  api_logging_level          = var.api_logging_level
  api_template               = file("../../services/api/${local.api_name}.yml")
  api_template_vars = {
    region = var.region

    cognito_user_pool_arn = module.cognito.cognito_user_pool_arn

    lambda_identity_arn     = module.identity.lambda_arn
    lambda_identity_timeout = var.lambda_identity_api_timeout

    lambda_user_arn     = module.user.lambda_arn
    lambda_user_timeout = var.lambda_user_api_timeout
  }

  xray_tracing_enabled = var.xray_tracing_enabled

  lambda_zip_name = local.lambda_zip_name
  dist_file_path  = local.dist_file_path

  resources = var.api_resources
}

# -----------------------------------------------------------------------------
# Lambda services
# -----------------------------------------------------------------------------
module "identity" {
  source = "../../services/identity"

  resource_tag_name = var.resource_tag_name
  namespace         = var.namespace
  region            = var.region

  lambda_layer_arn = module.lambda-layer.arn
  lambda_zip_name  = local.lambda_zip_name
  dist_path        = local.dist_file_path

  lambda_memory_size = var.lambda_identity_memory_size
  lambda_timeout     = var.lambda_identity_timeout

  cognito_user_pool_arn       = module.cognito.cognito_user_pool_arn
  cognito_user_pool_client_id = module.cognito.cognito_user_pool_client_id
  cognito_user_pool_id        = module.cognito.cognito_user_pool_id

  api_gateway_deployment_execution_arn = module.apigateway.deployment_execution_arn
  api_gateway_rest_api_id              = module.apigateway.rest_api_id

  debug_sample_rate = var.debug_sample_rate
}

module "user" {
  source = "../../services/user"

  resource_tag_name = var.resource_tag_name
  namespace         = var.namespace
  region            = var.region

  lambda_layer_arn = module.lambda-layer.arn
  lambda_zip_name  = local.lambda_zip_name
  dist_path        = local.dist_file_path

  lambda_memory_size = var.lambda_user_memory_size
  lambda_timeout     = var.lambda_user_timeout

  cognito_user_pool_arn       = module.cognito.cognito_user_pool_arn
  cognito_user_pool_client_id = module.cognito.cognito_user_pool_client_id
  cognito_user_pool_id        = module.cognito.cognito_user_pool_id

  api_gateway_deployment_execution_arn = module.apigateway.deployment_execution_arn
  api_gateway_rest_api_id              = module.apigateway.rest_api_id

  debug_sample_rate = var.debug_sample_rate
}
