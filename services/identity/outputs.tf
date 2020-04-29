output "iam_arn" {
  value = module.iam.role_arn
}

output "identity_canary_alarm_arn" {
  value = module.cloudwatch_alarms.canary_alarm_arn
}