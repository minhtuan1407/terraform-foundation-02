locals {
  owners      = var.buissiness_division
  environment = var.environment
  name        = "${var.buissiness_division}-${var.environment}"

  common_tags = {
    owner       = local.owners
    environment = local.environment
  }
}