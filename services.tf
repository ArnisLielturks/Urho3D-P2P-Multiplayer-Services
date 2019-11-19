# Create new droplet with docker installed
resource "digitalocean_droplet" "p2p-services" {
  image    = "docker-18-04"
  name     = "p2p-services"
  region   = "${var.do_region}"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.server-key.fingerprint]

  # Set up SSH connection
  connection {
    host        = "${digitalocean_droplet.p2p-services.ipv4_address}"
    user        = "root"
    type        = "ssh"
    private_key = file("./keys/id_rsa")
    timeout     = "2m"
  }

  # Run script after droplet has been created
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",

      # Start NAT master server docker container
      "docker run -d -p 61111:61111/udp arnislielturks/slikenet-nat-server:6",

      # Start P2P Session master server
      "docker run -d -p 80:4000 arnislielturks/master-server:latest"
    ]
  }
}

# Allow incomming traffic for the server
resource "digitalocean_firewall" "p2p-services-firewall" {
  name = "p2p-services-firewall"

  droplet_ids = [
    digitalocean_droplet.p2p-services.id,
  ]

  inbound_rule {
    protocol         = "udp"
    port_range       = "61111"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  depends_on = [digitalocean_droplet.p2p-services]
}

# Output information about our server
output "p2p_nat_punchtrough_server" {
  description = "IP address to the server"
  value       = "${digitalocean_droplet.p2p-services.ipv4_address}:61111"
}

output "p2p_session_master_server" {
  description = "Url to the service"
  value       = "http://${digitalocean_droplet.p2p-services.ipv4_address}"
}