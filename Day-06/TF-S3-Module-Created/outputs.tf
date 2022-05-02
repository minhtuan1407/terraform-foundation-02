output "arn" {
  description = "ARN of the S3 bucket"
  value = module.tf_module_s3_bucket.arn
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value = module.tf_module_s3_bucket.name
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value = module.tf_module_s3_bucket.domain
}