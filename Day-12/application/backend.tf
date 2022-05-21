terraform {
  backend "consul" {
    address = "192.168.1.10:8500"
    scheme  = "http"
  }
}