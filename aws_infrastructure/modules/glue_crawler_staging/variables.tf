
variable "database_name" {
  description = "Glue database name for staging data"
  type        = string
}

variable "staging_bucket_name" {
  description = "S3 bucket containing Parquet staging data"
  type        = string
}
