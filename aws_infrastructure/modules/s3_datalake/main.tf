
# RAW bucket
resource "aws_s3_bucket" "raw_datalake" {
  bucket = var.raw_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "raw_versioning" {
  bucket = aws_s3_bucket.raw_datalake.id
  versioning_configuration {
    status = "Enabled"
  }
}

# STAGING bucket
resource "aws_s3_bucket" "staging_datalake" {
  bucket = var.staging_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "staging_versioning" {
  bucket = aws_s3_bucket.staging_datalake.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Folder structure for RAW bucket
resource "aws_s3_object" "raw_folders" {
  for_each = toset(["landingzone", "clientes", "proveedores", "transacciones"])
  bucket   = aws_s3_bucket.raw_datalake.id
  key      = "${each.key}/"
  content  = ""
}

# Folder structure for STAGING bucket
resource "aws_s3_object" "staging_folders" {
  for_each = toset(["clientes", "proveedores", "transacciones"])
  bucket   = aws_s3_bucket.staging_datalake.id
  key      = "${each.key}/"
  content  = ""
}
