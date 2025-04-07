
output "raw_bucket_name" {
  value = aws_s3_bucket.raw_datalake.bucket
}

output "staging_bucket_name" {
  value = aws_s3_bucket.staging_datalake.bucket
}
