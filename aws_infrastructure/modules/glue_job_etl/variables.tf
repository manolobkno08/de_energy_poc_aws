
variable "glue_job_role_name" {
  type        = string
  description = "IAM role name for the Glue jobs"
  default     = "glue_etl_job_role"
}

variable "scripts_bucket_name" {
  type        = string
  description = "S3 bucket that contains the ETL scripts"
}
