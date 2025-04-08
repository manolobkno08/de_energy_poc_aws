
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_landingzone_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "lambda_landingzone_policy"
  role = aws_iam_role.lambda_exec_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::demo-useast2-dev-dl-raw-bucket",
          "arn:aws:s3:::demo-useast2-dev-dl-raw-bucket/*"
        ]
      },
      {
        Action   = "logs:*",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "landingzone_lambda" {
  function_name    = "lambda_landingzone"
  runtime          = "python3.9"
  handler          = "index.lambda_handler"
  role             = aws_iam_role.lambda_exec_role.arn
  timeout          = 30
  filename         = "${path.module}/lambda_package.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_package.zip")
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.landingzone_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::demo-useast2-dev-dl-raw-bucket"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "demo-useast2-dev-dl-raw-bucket"

  lambda_function {
    lambda_function_arn = aws_lambda_function.landingzone_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "landingzone/"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
