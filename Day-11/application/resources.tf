##############################################################################
# VERSIONS
##############################################################################
terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.0"
    }
  }
}

##############################################################################
# PROVIDERS
##############################################################################
provider "aws" {
  region  = var.region
  profile = "minhtuan1407-us-east-1"
}

provider "consul" {
  address    = "${var.consul_address}:${var.consul_port}"
  datacenter = var.consul_datacenter
}

##############################################################################
# DATA
##############################################################################
data "aws_availability_zones" "available" {}



##############################################################################
# LOCALS
##############################################################################
locals {
  asg_instance_size = jsondecode(data.consul_keys.applications.var.applications)["asg_instance_size"]
  asg_max_size      = jsondecode(data.consul_keys.applications.var.applications)["asg_max_size"]
  asg_min_size      = jsondecode(data.consul_keys.applications.var.applications)["asg_min_size"]
  rds_storage_size  = jsondecode(data.consul_keys.applications.var.applications)["rds_storage_size"]
  rds_engine        = jsondecode(data.consul_keys.applications.var.applications)["rds_engine"]
  rds_version       = jsondecode(data.consul_keys.applications.var.applications)["rds_version"]
  rds_instance_size = jsondecode(data.consul_keys.applications.var.applications)["rds_instance_size"]
  rds_multi_az      = jsondecode(data.consul_keys.applications.var.applications)["rds_multi_az"]
  rds_db_name       = jsondecode(data.consul_keys.applications.var.applications)["rds_db_name"]

  common_tags = merge(jsondecode(data.consul_keys.applications.var.common-tags),
    {
      Enviromnent = terraform.workspace
    }
  )
}
##############################################################################
# RESOURCES
##############################################################################

resource "aws_launch_configuration" "web_lc" {
  lifecycle {
    create_before_destroy = true
  }
  name_prefix   = "${terraform.workspace}-dtt-lc"
  image_id      = data.aws_ami.aws_linux.id
  instance_type = local.asg_instance_size

  security_groups = [
    aws_security_group.webapp_http_inbound_sg.id,
    aws_security_group.webapp_outbound_sg.id,
    aws_security_group.webapp_ssh_inbound_sg.id
  ]

  user_data                   = file("./templates/userdata.sh")
  associate_public_ip_address = true
}
# Networking
resource "aws_elb" "web_elb" {
  name    = "dtt-webapp-elb-${terraform.workspace}"
  subnets = data.terraform_remote_state.networking.outputs.public_subnet

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 3
    target              = "HTTP:80/"
  }

  security_groups = [aws_security_group.webapp_http_inbound_sg.id]

  tags = merge(local.common_tags)
}

resource "aws_autoscaling_group" "webapp_asg" {
  lifecycle {
    create_before_destroy = true
  }
  vpc_zone_identifier   = data.terraform_remote_state.networking.outputs.public_subnet
  name                  = "dtt_webapp_asg-${terraform.workspace}"
  max_size              = local.asg_max_size
  min_size              = local.asg_min_size
  wait_for_elb_capacity = local.asg_min_size
  force_delete          = true
  launch_configuration  = aws_launch_configuration.web_lc.id
  load_balancers        = [aws_elb.web_elb.id]

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "dtt_ast_scale_up-${terraform.workspace}"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name                = "dtt-high-asg-cpu-${terraform.workspace}"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "Scale up if CPU > 80%"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "dtt_ast_scale_down-${terraform.workspace}"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 600
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name                = "dtt-low-asg-cpu-${terraform.workspace}"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "5"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "30"
  alarm_description         = "Scale down if CPU < 30%"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${terraform.workspace}-dtt-db-subnet-group"
  subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet
}

resource "aws_db_instance" "rds" {
  identifier             = "${terraform.workspace}-dtt-rds"
  allocated_storage      = local.rds_storage_size
  engine                 = local.rds_engine
  engine_version         = local.rds_version
  instance_class         = local.rds_instance_size
  multi_az               = local.rds_multi_az
  name                   = "${terraform.workspace}${local.rds_db_name}"
  username               = var.rds_username
  password               = var.rds_passsword
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true

  tags = local.common_tags
}