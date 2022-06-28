data "aws_ec2_instance_type_offering" "my_ins_type2" {

  for_each = toset(["us-east-1a", "us-east-1b", "us-east-1c"])

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

# output "output_v1_1" {
#   value = data.aws_ec2_instance_type_offering.my_ins_type1.instance_type
# }

output "output_v2_1" {
  # value = data.aws_ec2_instance_type_offering.my_ins_type2.instance_type
  value = toset([for nvmtuan in data.aws_ec2_instance_type_offering.my_ins_type2 : nvmtuan.instance_type])
}

# Create a map with key as availability zone and value as list of instance types supported
output "output_v2_2" {
  value = {
    for az, detail in data.aws_ec2_instance_type_offering.my_ins_type2 : az => detail.instance_type
  }
}