output "iam_arn" {
  value = module.iam.role_arn
}

output "sns_topic_arn" {
  value = module.sns.sns_topic_arn_lambda
}

output "user_canary_alarm_arn" {
  value = module.cloudwatch_alarms_user.canary_alarm_arn
}

output "user_receiver_canary_alarm_arn" {
  value = module.cloudwatch_alarms_user_receiver.canary_alarm_arn
}