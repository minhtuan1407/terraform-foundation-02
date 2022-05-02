output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "Private subnets of the VPC"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnets of the VPC"
  value       = module.vpc.public_subnets
}

output "nat_public_ips" {
  description = "Public IPs of NAT gateways"
  value       = module.vpc.nat_public_ips
}

output "azs" {
  description = "Availability zones of the VPC"
  value       = module.vpc.azs
}