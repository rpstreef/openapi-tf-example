locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"

  lambda_function_user_name          = "user"
  lambda_function_user_receiver_name = "user-receiver"

  local_sns_topic_name = "user-topic"
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
  role_name          = "${local.lambda_function_user_name}-role"
  policy_name        = "${local.lambda_function_user_name}-policy"

  role_vars = {
    cognito_user_pool_arn = var.cognito_user_pool_arn
    sns_topic_arn         = module.sns.sns_topic_arn_lambda
  }
}

# -----------------------------------------------------------------------------
# Module: Lambda User
# -----------------------------------------------------------------------------
resource "aws_lambda_permission" "_" {
  principal     = "apigateway.amazonaws.com"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_user_arn

  source_arn = "arn:aws:execute-api:${
    var.region
    }:${
    data.aws_caller_identity._.account_id
    }:${
    var.api_gateway_rest_api_id
  }/*/*"
}

module "cloudwatch_alarms_user" {
  source = "github.com/rpstreef/terraform-aws-cloudwatch-alarms"

  namespace         = var.namespace
  region            = var.region
  resource_tag_name = var.resource_tag_name
  
  create_canary_alarm          = false
  create_iteratorAge_alarm     = false
  create_deadLetterQueue_alarm = false

  lambda_function_name = "${local.resource_name_prefix}-${local.lambda_function_user_name}"
}

# -----------------------------------------------------------------------------
# Module: SNS User receiver integration
# -----------------------------------------------------------------------------
module "sns" {
  source = "github.com/rpstreef/tf-sns-topic?ref=v1.1"

  namespace         = var.namespace
  region            = var.region
  resource_tag_name = var.resource_tag_name

  topic_name          = local.local_sns_topic_name
  lambda_function_arn = var.lambda_function_userReceiver_arn
}

module "cloudwatch_alarms_user_receiver" {
  source = "github.com/rpstreef/terraform-aws-cloudwatch-alarms"

  namespace         = var.namespace
  region            = var.region
  resource_tag_name = var.resource_tag_name

  create_canary_alarm          = false
  create_iteratorAge_alarm     = false
  create_deadLetterQueue_alarm = false

  lambda_function_name = "${local.resource_name_prefix}-${local.lambda_function_user_receiver_name}"
}
