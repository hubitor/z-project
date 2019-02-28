resource "google_compute_instance" "worker" {
  count        = "${var.instance_count}"
  name         = "${var.name}-${count.index}"
  machine_type = "custom-1-6144"
  zone         = "${var.zone}"
  tags         = "${var.tags}"
  can_ip_forward = "true"

  boot_disk {
    initialize_params {
      image = "${var.worker_disk_image}"
    }
  }

  network_interface {
    subnetwork   = "${var.subnet}"
    address   = "${cidrhost(var.address,count.index+20)}"

  access_config = {}
  }

  metadata {
    pod-cidr = "${cidrsubnet(var.pods_range,8,count.index)}"
    ssh-keys = "shma:${file(var.public_key_path)}"
  }

  service_account {
    scopes = [ "compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring" ]
  }
  

}

