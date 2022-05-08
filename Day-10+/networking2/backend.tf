terraform {
  backend "consul" {
    address = "192.168.1.10:8500"
    scheme  = "http"
    # path = networking/state/globo-primary
    access_token = "e8e50325-9bc2-d293-8e34-a51b1dfb586b"
  }
}