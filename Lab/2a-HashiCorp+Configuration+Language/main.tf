provider "aws" {
  access_key = "AKIASS4QLD2WPNDICYMN"
  secret_key = "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"
  region     = "ap-southeast-1"
}
resource "aws_instance" "web" {
  ami                    = "ami-0801a1e12f4a9ccc0"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0347d9dbdc4507510"
  vpc_security_group_ids = ["sg-029945cd2e7237286"]
  tags = {
    "Identity" = "terraform-provider-aws-example"
  }
}
