resource "digitalocean_vpc" "test-vpc" {
  name     = "test-vpc"
  region   = "fra1"
  ip_range = "10.0.0.0/24"
}