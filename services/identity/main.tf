locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"

  lambda_function_name = "identity"
}

# -----------------------------------------------------------------------------
# Data: aws_caller_identity gets data from current AWS account
# -----------------------------------------------------------------------------
data "aws_caller_identity" "_" {}

# -----------------------------------------------------------------------------
# Module: IAM role
# -----------------------------------------------------------------------------
module "iam" {
  source = "../../modules/iam"

  namespace         = var.namespace
  region            = var.region
  resource_tag_name = var.resource_tag_name

  assume_role_policy = file("${path.module}/policies/lambda-assume-role.json")
  template           = file("${path.module}/policies/lambda.json")
  role_name          = "${local.lambda_function_name}-role"
  policy_name        = "${local.lambda_function_name}-policy"

  role_vars = {
    cognito_user_pool_arn = var.cognito_user_pool_arn
  }
}

# -----------------------------------------------------------------------------
# Module: Lambda
# -----------------------------------------------------------------------------
module "lambda" {
  source = "github.com/rpstreef/tf-lambda?ref=v1.0"

  namespace         = var.namespace
  region            = var.region
  resource_tag_name = var.resource_tag_name

  lambda_function_name = local.lambda_function_name
  lambda_role_arn      = module.iam.role_arn
  lambda_filename      = "${var.dist_path}/${var.lambda_zip_name}"
  lambda_layer_arn     = var.lambda_layer_arn

  lambda_memory_size = var.lambda_memory_size
  lambda_timeout     = var.lambda_timeout

  distribution_file_name = var.lambda_zip_name

  dist_path = var.dist_path

  lambda_environment_variables = {
    NAMESPACE = var.namespace
    REGION    = var.region

    COGNITO_USER_POOL_CLIENT_ID = var.cognito_user_pool_client_id
    COGNITO_USER_POOL_ID        = var.cognito_user_pool_id

    DEBUG_SAMPLE_RATE = var.debug_sample_rate
  }

  create_deadLetterQueue_alarm = false
  create_iteratorAge_alarm     = false

  api_gateway_rest_api_id = var.api_gateway_rest_api_id
}
