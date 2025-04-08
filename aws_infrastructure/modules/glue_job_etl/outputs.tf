
output "glue_job_names" {
  value = [for j in aws_glue_job.etl_jobs : j.name]
}
