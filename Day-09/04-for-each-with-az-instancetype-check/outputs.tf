output "instances_public_ip" {
  description = "EC2 Instances public IP"
  value       = toset([for instance in aws_instance.myec2vm : instance.public_ip])
}

output "instances_public_dns" {
  description = "EC2 Instances public DNS"
  value       = toset([for instance in aws_instance.myec2vm : instance.public_dns])
}