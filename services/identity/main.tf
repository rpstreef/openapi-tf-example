locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"

  lambda_function_name = "identity"
}

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