variable "region" {
  default = "us-east-1"
}

variable "consul_address" {
  type        = string
  description = "The address of the Consul server"
  default     = "192.168.1.10"
}

variable "consul_port" {
  type        = number
  description = "The port of the Consul server"
  default     = 8500
}

variable "consul_datacenter" {
  type        = string
  description = "The datacenter of the Consul server"
  default     = "dc1"
}