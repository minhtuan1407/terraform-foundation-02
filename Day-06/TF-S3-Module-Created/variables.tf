variable "my_bucket" {
  description = "S3 bucket that was passed to s3 custom module"
  type = string
  default = "nguyenvuminhtuan-1407"
}

variable "my_tags" {
  description = "Tags that was passed to s3 custom module"
  type = map(string)
  default = {
    "Terraform" = "true"
    "Environment" = "dev"
    "CreatedBy" = "devops-team"
  }
}