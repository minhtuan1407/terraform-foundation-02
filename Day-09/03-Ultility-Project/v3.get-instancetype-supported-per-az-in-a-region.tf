data "aws_availability_zones" "myzone" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ec2_instance_type_offerings" "my_ins_type3" {

  for_each = toset(data.aws_availability_zones.myzone.names)

  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  filter {
    name   = "location"
    values = [each.key]
  }

  location_type = "availability-zone"
}

# Output 1
# Basic output all available instance types in a region mapped to their instance types
output "output_v3_1" {
  value = {
    for az, detail in data.aws_ec2_instance_type_offerings.my_ins_type3 : az => detail.instance_types
  }
}

# Output 2
# Filtered output: Exclude all instance types that are not supported in a region
output "output_v3_2" {
  value = {
    for az, detail in data.aws_ec2_instance_type_offerings.my_ins_type3 :
    az => detail.instance_types if length(detail.instance_types) > 0
  }
}

output "output_v3_3" {
  value = keys({
    for az, detail in data.aws_ec2_instance_type_offerings.my_ins_type3 :
    az => detail.instance_types if length(detail.instance_types) != 0
  })
}