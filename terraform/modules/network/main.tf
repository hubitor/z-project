resource "google_compute_subnetwork" "kubernetes" {
  name          = "${var.subnetwork_name}"
  ip_cidr_range = "${var.kubernetes_ip_range}"
  region        = "${var.region}"
  network       = "${google_compute_network.kubernetes-the-hard-way.self_link}"
}

resource "google_compute_network" "kubernetes-the-hard-way" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "kubernetes-the-hard-way-allow-internal" {
  name    = "kubernetes-the-hard-way-allow-internal"
  network = "${google_compute_network.kubernetes-the-hard-way.self_link}"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [ "${var.kubernetes_ip_range}", "${var.pods_ip_range}" ]
}

resource "google_compute_firewall" "kubernetes-the-hard-way-allow-external" {
  name    = "kubernetes-the-hard-way-allow-external"
  network = "${google_compute_network.kubernetes-the-hard-way.self_link}"

  allow {
    protocol = "tcp"
    ports = ["22", "6443", "80", "443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [ "0.0.0.0/0" ]

}

resource "google_compute_address" "kubernetes-the-hard-way" {
  name = "kubernetes-the-hard-way"
  region = "${var.region}"
}

resource "google_compute_route" "kubernetes-route" {
  depends_on  = [ "google_compute_subnetwork.kubernetes" ]
  count       = "${var.instance_count}"
  name        = "kubernetes-route-10-200-${count.index}-0-24"
  dest_range  = "10.200.${count.index}.0/24"
  network     = "${google_compute_network.kubernetes-the-hard-way.self_link}"
  next_hop_ip = "10.240.0.2${count.index}"
  priority    = 1000
}
