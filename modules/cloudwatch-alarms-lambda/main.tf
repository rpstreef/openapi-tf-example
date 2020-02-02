locals {
  errorRate_name       = "${var.function_name} - ${floor(var.errorRate_threshold * 100)}% over the last ${var.errorRate_evaluationPeriods} mins"
  throttleCount_name   = "${var.function_name} - ${var.throttleCount_threshold} over the last ${var.throttleCount_evaluationPeriods} mins"
  iteratorAge_name     = "${var.function_name} - ${var.iteratorAge_threshold}ms over the last ${var.iteratorAge_evaluationPeriods} mins"
  deadLetterQueue_name = "${var.function_name} - ${var.deadLetterQueue_threshold} over the last ${var.deadLetterQueue_evaluationPeriods} mins"
}

resource "aws_cloudwatch_metric_alarm" "errorRate" {
  count = var.create_errorRate_alarm ? 1 : 0

  alarm_name                = local.errorRate_name
  alarm_description         = local.errorRate_name
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.errorRate_evaluationPeriods
  threshold                 = var.errorRate_threshold
  insufficient_data_actions = []

  metric_query {
    id          = "errorRate"
    label       = "Error Rate (%)"
    expression  = "errors / invocations"
    return_data = true
  }

  metric_query {
    id    = "invocations"
    label = "Invocations"

    metric {
      metric_name = "Invocations"
      namespace   = "AWS/Lambda"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        FunctionName = var.function_name
      }
    }

    return_data = false
  }

  metric_query {
    id    = "errors"
    label = "Errors"

    metric {
      metric_name = "Invocations"
      namespace   = "AWS/Lambda"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        FunctionName = var.function_name
      }
    }

    return_data = false
  }

  tags = {
    Name        = var.resource_tag_name
    Environment = var.namespace
  }
}

resource "aws_cloudwatch_metric_alarm" "throttleCount" {
  count = var.create_throttleCount_alarm ? 1 : 0

  alarm_name          = local.throttleCount_name
  alarm_description   = local.throttleCount_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.throttleCount_evaluationPeriods
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.throttleCount_threshold

  dimensions = {
    FunctionName = var.function_name
  }

  tags = {
    Name        = var.resource_tag_name
    Environment = var.namespace
  }
}

resource "aws_cloudwatch_metric_alarm" "iteratorAge" {
  count = var.create_iteratorAge_alarm ? 1 : 0

  alarm_name          = local.iteratorAge_name
  alarm_description   = local.iteratorAge_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.iteratorAge_evaluationPeriods
  metric_name         = "IteratorAge"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.iteratorAge_threshold

  dimensions = {
    FunctionName = var.function_name
  }

  tags = {
    Name        = var.resource_tag_name
    Environment = var.namespace
  }
}

resource "aws_cloudwatch_metric_alarm" "deadLetterQueue" {
  count = var.create_deadLetterQueue_alarm ? 1 : 0

  alarm_name          = local.deadLetterQueue_name
  alarm_description   = local.deadLetterQueue_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.deadLetterQueue_evaluationPeriods
  metric_name         = "DeadLetterErrors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.deadLetterQueue_threshold

  dimensions = {
    FunctionName = var.function_name
  }

  tags = {
    Name        = var.resource_tag_name
    Environment = var.namespace
  }
}
