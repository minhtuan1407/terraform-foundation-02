variable "bucket_name" {
  description = "Name of the s3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags for the s3 bucket"
  type        = map(string)
  default     = {}
}