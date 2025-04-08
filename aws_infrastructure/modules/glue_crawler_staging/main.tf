
resource "aws_iam_role" "glue_role" {
  name = "glue_staging_crawler_role"
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
  name = "glue_staging_crawler_policy"
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
          "arn:aws:s3:::${var.staging_bucket_name}",
          "arn:aws:s3:::${var.staging_bucket_name}/*"
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

resource "aws_glue_crawler" "staging_crawler" {
  name          = "staging_crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = var.database_name

  s3_target {
    path = "s3://${var.staging_bucket_name}/"
  }

  classifiers = []
  schedule    = null
}
