output "table_name" {
  value       = concat(aws_dynamodb_table.dynamodb_table.*.name, [""])[0]
  description = "DynamoDB table name"
}

output "table_id" {
  value       = concat(aws_dynamodb_table.dynamodb_table.*.id, [""])[0]
  description = "DynamoDB table ID"
}

output "table_arn" {
  value       = concat(aws_dynamodb_table.dynamodb_table.*.arn, [""])[0]
  description = "DynamoDB table ARN"
}