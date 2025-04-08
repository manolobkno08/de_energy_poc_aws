
output "raw_database_name" {
  value = aws_glue_catalog_database.raw.name
}

output "staging_database_name" {
  value = aws_glue_catalog_database.staging.name
}
