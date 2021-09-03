output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "user_id" {
value = data.aws_caller_identity.current.user_id
}

output "region_name" {
  value = data.aws_region.current.name
}

