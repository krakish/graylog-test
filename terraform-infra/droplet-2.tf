resource "digitalocean_firewall" "droplet-2-firewall" {
  name        = "droplet-2-firewall"
  droplet_ids = [digitalocean_droplet.droplet-2.id]

  inbound_rule {
    protocol           = "tcp"
    port_range         = "22"
    source_addresses = ["0.0.0.0/0"]
  }

   outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_tag" "droplet-2-tag" {
  name = "droplet-2"
}


resource "digitalocean_droplet" "droplet-2" {
  image    = "ubuntu-22-04-x64"
  name     = "droplet-2"
  region   = "fra1"
  size     = "s-1vcpu-512mb-10gb"
  vpc_uuid = resource.digitalocean_vpc.test-vpc.id
  ssh_keys = [data.digitalocean_ssh_key.wind-key.id]
  user_data = file("./user-data-docker.sh")
  monitoring = true
  tags       = [digitalocean_tag.droplet-2-tag.id]
}

