
variable "raw_bucket_name" {
  description = "Nombre del bucket RAW"
  type        = string
}

variable "staging_bucket_name" {
  description = "Nombre del bucket STAGING (procesado)"
  type        = string
}

variable "scripts_bucket_name" {
  description = "Nombre del bucket para scripts de Glue"
  type        = string
}
