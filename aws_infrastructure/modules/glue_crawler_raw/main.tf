
resource "aws_iam_role" "glue_role" {
  name = "glue_raw_crawler_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "glue_policy" {
  name = "glue_raw_crawler_policy"
  role = aws_iam_role.glue_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.raw_bucket_name}",
          "arn:aws:s3:::${var.raw_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "glue:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_glue_classifier" "csv_classifier" {
  name = "csv_classifier_utf8_comma"

  csv_classifier {
    allow_single_column = false
    contains_header     = "PRESENT"
    delimiter           = ","
    quote_symbol        = "\""
    disable_value_trimming = false
    header              = []
  }
}

resource "aws_glue_crawler" "raw_crawler" {
  name          = "raw_crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = var.database_name

  s3_target {
    path = "s3://${var.raw_bucket_name}/"
  }

  classifiers = [aws_glue_classifier.csv_classifier.name]
  schedule    = null
}
