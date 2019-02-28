resource "google_compute_instance" "controller" {
  count        = "${var.instance_count}"
  name         = "${var.name}-${count.index}"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = "${var.tags}"
  can_ip_forward = "true"

  boot_disk {
    initialize_params {
      image = "${var.controller_disk_image}"
    }
  }

  network_interface {
    subnetwork   = "${var.subnet}"
    address   = "${cidrhost(var.address,count.index+10)}"

  access_config = {}
  }

  metadata {
    ssh-keys = "shma:${file(var.public_key_path)}"
  }

  service_account {
    scopes = [ "compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring" ]
  }


}

