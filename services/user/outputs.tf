output "iam_arn" {
  value = module.iam.role_arn
}

output "sns_topic_arn" {
  value = module.sns.sns_topic_arn_lambda
}