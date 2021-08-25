output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "user_id" {
value = data.aws_caller_identity.current.user_id
}

output "region_name" {
  value = data.aws_region.current.name
}

output "private_ip" {
 value = data.aws_instance.current.private_ip
}

output "subnet_id" {
 value = data.aws_instance.current.subnet_id
}
