terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

module "s3_datalake" {
  source      = "./modules/s3_datalake"
  raw_bucket_name     = "demo-useast2-dev-dl-raw-bucket"
  staging_bucket_name = "demo-useast2-dev-dl-staging-bucket"
}

module "lambda_landingzone" {
  source = "./modules/lambda_landingzone"
}
