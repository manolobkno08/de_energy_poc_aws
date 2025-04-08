variable "database_name" {
  description = "Glue database name for RAW data"
  type        = string
}

variable "raw_bucket_name" {
  description = "S3 bucket containing raw data"
  type        = string
}