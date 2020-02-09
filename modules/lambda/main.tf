# -----------------------------------------------------------------------------
# Locals
# -----------------------------------------------------------------------------
locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"
  function_name        = "${local.resource_name_prefix}-${var.lambda_function_name}"
}

# -----------------------------------------------------------------------------
# Resources: Lambda Register
# -----------------------------------------------------------------------------
resource "aws_lambda_function" "_" {
  function_name                  = local.function_name
  role                           = var.lambda_role_arn
  runtime                        = var.lambda_runtime
  filename                       = var.lambda_filename
  handler                        = "handlers/${var.lambda_function_name}/index.handler"
  timeout                        = var.lambda_timeout
  memory_size                    = var.lambda_memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions

  source_code_hash = filebase64sha256("${var.dist_path}/${var.distribution_file_name}")

  layers = ["${var.lambda_layer_arn}"]

  tracing_config {
    mode = var.tracing_config_mode
  }

  environment {
    variables = var.lambda_environment_variables
  }

  tags = {
    Environment = var.namespace
    Name        = var.resource_tag_name
  }
}

resource "aws_cloudwatch_log_group" "_" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = var.log_retention_in_days
}
