output "topic_arn" {
  value = aws_sns_topic._.arn
}

output "topic_name" {
  value = "${local.resource_name_prefix}-${var.topic_name}"
}
