#ocals {
## migration_var = "terraform init -migrate-state -backend-config="bucket=${aws_s3_bucket.tfstate.bucket}" -backend-config="region=${var.aws_region}" -backend-config="key=${aws_s3_bucket.tfstate.bucket}.tfstate" -backend-config="dynamodb_table=${aws_dynamodb_table.terraform.name}""
#

output "s3_state_bucket_name" {
  value = aws_s3_bucket.tfstate[*].bucket
}

output "dynamo_db_table_name" {
  value = aws_dynamodb_table.terraform[*].name
}

#output "migration_cmd" {
#  value = local.migration_var
#}