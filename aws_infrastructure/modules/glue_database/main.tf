
resource "aws_glue_catalog_database" "raw" {
  name = var.raw_database_name
}

resource "aws_glue_catalog_database" "staging" {
  name = var.staging_database_name
}
