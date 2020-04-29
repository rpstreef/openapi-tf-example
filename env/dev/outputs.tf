output "cognito_user_pool_arn" {
  value = module.cognito.cognito_user_pool_arn
}

output "cognito_user_pool_client_id" {
  value = module.cognito.cognito_user_pool_client_id
}

output "cognito_identity_pool_id" {
  value = module.cognito.cognito_identity_pool_id
}

output "identity_role_arn" {
  value = module.identity.iam_arn
}

output "user_role_arn" {
  value = module.user.iam_arn
}

output "sns_topic_arn" {
  value = module.user.sns_topic_arn
}

output "identity_canary_alarm_arn" {
  value = module.identity.identity_canary_alarm_arn
}

output "user_canary_alarm_arn" {
  value = module.user.user_canary_alarm_arn
}

output "user_receiver_canary_alarm_arn" {
  value = module.user.user_receiver_canary_alarm_arn
}