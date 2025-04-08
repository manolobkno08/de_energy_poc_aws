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
  scripts_bucket_name = "demo-useast2-dev-dl-scripts-bucket"
}

module "lambda_landingzone" {
  source = "./modules/lambda_landingzone"
}

module "glue_database" {
  source = "./modules/glue_database"
  raw_database_name     = "energy_datalake_raw"
  staging_database_name = "energy_datalake_staging"
}

module "glue_crawler_raw" {
  source             = "./modules/glue_crawler_raw"
  database_name      = "energy_datalake_raw"
  raw_bucket_name    = "demo-useast2-dev-dl-raw-bucket"
}

module "glue_crawler_staging" {
  source             = "./modules/glue_crawler_staging"
  database_name      = "energy_datalake_staging"
  staging_bucket_name = "demo-useast2-dev-dl-staging-bucket"
}

module "glue_job_etl" {
  source             = "./modules/glue_job_etl"
  scripts_bucket_name = "demo-useast2-dev-dl-scripts-bucket"
}

