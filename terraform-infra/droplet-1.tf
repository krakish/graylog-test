resource "digitalocean_firewall" "droplet-1-firewall" {
  name        = "droplet-1-firewall"
  droplet_ids = [digitalocean_droplet.droplet-1.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "9000"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "5044"
    source_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_tag" "droplet-1-tag" {
  name = "droplet-1"
}


resource "digitalocean_droplet" "droplet-1" {
  image      = "ubuntu-22-04-x64"
  name       = "droplet-1"
  region     = "fra1"
  size       = "s-2vcpu-4gb"
  vpc_uuid   = resource.digitalocean_vpc.test-vpc.id
  ssh_keys   = [data.digitalocean_ssh_key.wind-key.id]
  user_data  = file("./user-data-docker.sh")
  monitoring = true
  tags       = [digitalocean_tag.droplet-1-tag.id]
}

