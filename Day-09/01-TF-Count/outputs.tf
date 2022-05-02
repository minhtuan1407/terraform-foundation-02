## Output - For loop with list

output "for_output_lists" {
  description = "For loop with lists"
  value       = [for instance in aws_instance.myec2vm : instance.public_dns]
}

## Output - For loop with maps 01
output "for_output_maps_01" {
  description = "For loop with maps 01"
  value       = { for instance in aws_instance.myec2vm : instance.id => instance.public_dns }
}

## Output - For loop with maps 02
output "for_output_maps_02" {
  description = "For loop with maps 02"
  value       = { for c, instance in aws_instance.myec2vm : c => instance.public_dns }
}

## Output - Latest generalize splat operator return list
output "latest_splat_instance_public_dns" {
  description = "Generalize splat operator"
  value       = aws_instance.myec2vm[*].public_dns
}