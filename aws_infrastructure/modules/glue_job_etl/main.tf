
resource "aws_iam_role" "glue_role" {
  name = var.glue_job_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "glue_s3_policy" {
  name = "glue_etl_s3_policy"
  role = aws_iam_role.glue_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:*"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::demo-useast2-dev-dl-raw-bucket",
          "arn:aws:s3:::demo-useast2-dev-dl-raw-bucket/*",
          "arn:aws:s3:::demo-useast2-dev-dl-staging-bucket",
          "arn:aws:s3:::demo-useast2-dev-dl-staging-bucket/*",
          "arn:aws:s3:::${var.scripts_bucket_name}",
          "arn:aws:s3:::${var.scripts_bucket_name}/*"
        ]
      },
      {
        Action = [
          "logs:*"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

locals {
  job_scripts = {
    clientes      = "clientes/clientes_etl.py"
    proveedores   = "proveedores/proveedores_etl.py"
    transacciones = "transacciones/transacciones_etl.py"
  }
}

resource "aws_glue_job" "etl_jobs" {
  for_each = local.job_scripts

  name     = "glue_job_${each.key}"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.scripts_bucket_name}/${each.value}"
    python_version  = "3"
  }

  glue_version      = "4.0"
  max_retries       = 0
  number_of_workers = 2
  worker_type       = "G.1X"
}
