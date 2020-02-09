locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"
  sns_topic_policy_id  = "${var.namespace}-${var.resource_tag_name}-${var.topic_name}"
}

resource "aws_sns_topic" "_" {
  name = "${local.resource_name_prefix}-${var.topic_name}"

  tags = {
    Environment = var.namespace
    Name        = var.resource_tag_name
  }
}

resource "aws_sns_topic_subscription" "_" {
  topic_arn = aws_sns_topic._.arn
  protocol  = "lambda"
  endpoint  = var.lambda_function_arn
}

resource "aws_lambda_permission" "_" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic._.arn
}
