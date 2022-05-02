variable "sg-port" {
  type        = list(number)
  description = "This is variable for list of sg-port"
  default     = [8200, 8021, 8300, 8400]
}

# resource "aws_security_group" "demo-sg" {
#   name        = "sg-example"
#   description = "Ingress for Vault"

#   dynamic "ingress" {
#     for_each = var.sg-port
#     content {
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }

#   dynamic "egress" {
#     for_each = var.sg-port
#     content {
#       from_port   = egress.value
#       to_port     = egress.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }


resource "aws_security_group" "demo-sg" {
  name        = "sg-example"
  description = "Ingress for Vault"

  dynamic "ingress" {
    for_each = var.sg-port
    iterator = port

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.sg-port
    iterator = port

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}