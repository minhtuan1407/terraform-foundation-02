module "tf_module_s3_bucket" {
  source = "github.com/minhtuan1407/tf_module_s3_bucket.git"
  bucket_name = var.my_bucket
  tags = var.my_tags
}