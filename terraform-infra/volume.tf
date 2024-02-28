resource "digitalocean_volume" "logs-volume" {
  region                  = "fra1"
  name                    = "logs-volume"
  size                    = 30
  initial_filesystem_type = "ext4"
  description             = "volume for logs collection"
}

resource "digitalocean_volume_attachment" "volume-attachment" {
  droplet_id = digitalocean_droplet.droplet-1.id
  volume_id  = digitalocean_volume.logs-volume.id
}