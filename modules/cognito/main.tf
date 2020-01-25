locals {
  resource_name = "${var.namespace}-${var.resource_tag_name}"
}

# -----------------------------------------------------------------------------
# Resource: Cognito
# Remarks: Set for Schema String and Number attribute constraints to prevent redeployment (!)
# https://github.com/terraform-providers/terraform-provider-aws/issues/7502
# https://www.terraform.io/docs/providers/aws/r/cognito_user_pool.html#schema-attributes
# -----------------------------------------------------------------------------

resource "aws_cognito_user_pool" "_" {
  name                     = "${local.resource_name}-${var.cognito_identity_pool_name}"
  alias_attributes         = var.alias_attributes
  auto_verified_attributes = var.auto_verified_attributes

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }

  dynamic "schema" {
    for_each = var.schema_map
    
    content {
      name                = schema.value.name
      attribute_data_type = schema.value.attribute_data_type
      mutable             = schema.value.mutable
      required            = schema.value.required
    }
  }

  lifecycle {
    ignore_changes = [ schema ]
  }

  tags = {
    Environment = var.namespace
    Name        = var.resource_tag_name
  }
}

# -----------------------------------------------------------------------------
# Domain is required for email link to function:
# https://forums.aws.amazon.com/thread.jspa?threadID=262811
# -----------------------------------------------------------------------------
resource "aws_cognito_user_pool_domain" "_" {
  domain       = local.resource_name
  user_pool_id = aws_cognito_user_pool._.id
}

resource "aws_cognito_user_pool_client" "_" {
  name = "${local.resource_name}-client"

  user_pool_id    = aws_cognito_user_pool._.id
  generate_secret = false

  explicit_auth_flows = [
    "ADMIN_NO_SRP_AUTH",
    "USER_PASSWORD_AUTH",
  ]
}

resource "aws_cognito_identity_pool" "_" {
  identity_pool_name      = var.cognito_identity_pool_name
  developer_provider_name = var.cognito_identity_pool_provider

  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client._.id
    server_side_token_check = true

    provider_name = "cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool._.id}"
  }
}
