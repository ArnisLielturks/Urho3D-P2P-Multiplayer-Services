# Create a new SSH key
resource "digitalocean_ssh_key" "server-key" {
  name       = "P2P Multiplayer service stack keys"
  public_key = file("./keys/id_rsa.pub")
}
