resource "google_compute_instance" "nfs" {
  name         = "${var.name}"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = "${var.tags}"
  can_ip_forward = "false"

  boot_disk {
    initialize_params {
      image = "${var.nfs_disk_image}"
      size  = "${var.disk_size}"
    }
  }

  network_interface {
    subnetwork   = "${var.subnet}"
    address   = "${cidrhost(var.address,150)}"

  access_config = {}
  }

  metadata {
    ssh-keys = "shma:${file(var.public_key_path)}"
  }

  service_account {
    scopes = [ "compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring" ]
  }

}

