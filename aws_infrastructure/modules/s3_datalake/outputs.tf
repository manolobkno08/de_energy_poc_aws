
output "raw_bucket_name" {
  value = aws_s3_bucket.raw_datalake.bucket
}

output "staging_bucket_name" {
  value = aws_s3_bucket.staging_datalake.bucket
}

output "scripts_bucket_name" {
  value = aws_s3_bucket.scripts_bucket.bucket
}
