data "aws_ami" "aws_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.5.0"

  for_each = toset(["kien", "bao", "thi"])
  name     = "instance-${each.key}"

  create_spot_instance = true
  spot_price           = "0.60"
  spot_type            = "persistent"

  # name                    = "instance_module"
  ami                    = data.aws_ami.aws_linux.id
  instance_type          = "t2.micro"
  monitoring             = false
  key_name               = "minhtuan1407"
  vpc_security_group_ids = ["sg-06382741bc057f6e0"]
  subnet_id              = "subnet-078c94a03168a68fc"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}