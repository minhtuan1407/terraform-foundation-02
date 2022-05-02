terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "consul" {
  address    = "192.168.1.10:8500"
  datacenter = "dc1"
  token      = "e8e50325-9bc2-d293-8e34-a51b1dfb586b"
}

resource "consul_keys" "networking" {

  key {
    path  = "networking/configuration"
    value = ""
  }

  key {
    path  = "networking/state"
    value = ""
  }
}

resource "consul_keys" "application" {

  key {
    path  = "application/configuration"
    value = ""
  }

  key {
    path  = "application/state"
    value = ""
  }
}

resource "consul_acl_policy" "networking" {
  name = "networking"

  rules = <<-RULE
  key_prefix "networking" {
    policy = "write"
  }

  session_prefix "" {
    policy = "write"
  }
  RULE
}


resource "consul_acl_policy" "application" {
  name = "application"

  rules = <<-RULE
  key_prefix "application" {
    policy = "write"
  }

  session_prefix "networking/state" {
    policy = "read"
  }

  session_prefix "" {
    policy = "write"
  }
  RULE
}

resource "consul_acl_token" "marry" {
  description = "Token for marry"
  policies    = [consul_acl_policy.networking.name]
}

resource "consul_acl_token" "sally" {
  description = "Token for sally"
  policies    = [consul_acl_policy.application.name]
}

output "marry_token" {
  description = "This is token for marry"
  value = consul_acl_token.marry.id
}

output "sally_token" {
  description = "This is token for sally"
  value = consul_acl_token.sally.id
}