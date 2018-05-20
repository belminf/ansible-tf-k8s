variable "ssh_key_id" {
    type = "string"
}

variable "do_token" {
    type = "string"
}

variable "region" {
    type = "string"
}

variable "size" {
    type = "string"
}

variable "image_name" {
    type = "string"
}

provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_droplet" "master" {
  count = "1"
  name = "k8-master"
  private_networking = true
  image = "${var.image_name}"
  size = "${var.size}"
  region = "${var.region}"
  ssh_keys = ["${var.ssh_key_id}"]
}

resource "digitalocean_droplet" "knodes" {
  count = "2"
  name = "k8-node-${count.index}"
  private_networking = true
  image = "${var.image_name}"
  size = "${var.size}"
  region = "${var.region}"
  ssh_keys = ["${var.ssh_key_id}"]
}

output "master" {
    value = "${digitalocean_droplet.master.ipv4_address}"
}

output "nodes" {
    value = "${join(",", digitalocean_droplet.knodes.*.ipv4_address)}"
}
