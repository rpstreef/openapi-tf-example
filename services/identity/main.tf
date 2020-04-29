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
  source = "github.com/rpstreef/tf-iam?ref=v1.0"

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
# Module: Lambda Identity integration
# -----------------------------------------------------------------------------
resource "aws_lambda_permission" "_" {
  principal     = "apigateway.amazonaws.com"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_identity_arn

  source_arn = "arn:aws:execute-api:${
    var.region
    }:${
    data.aws_caller_identity._.account_id
    }:${
    var.api_gateway_rest_api_id
  }/*/*"
}

module "cloudwatch_alarms" {
  source = "github.com/rpstreef/terraform-aws-cloudwatch-alarms"

  namespace         = var.namespace
  region            = var.region
  resource_tag_name = var.resource_tag_name

  create_canary_alarm          = false
  create_iteratorAge_alarm     = false
  create_deadLetterQueue_alarm = false

  lambda_function_name = "${local.resource_name_prefix}-${local.lambda_function_name}"
}
