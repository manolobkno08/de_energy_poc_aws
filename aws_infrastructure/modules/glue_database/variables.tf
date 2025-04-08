
variable "raw_database_name" {
  description = "Name of the Glue database for raw data"
  type        = string
}

variable "staging_database_name" {
  description = "Name of the Glue database for staging (processed) data"
  type        = string
}
