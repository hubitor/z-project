resource "google_compute_http_health_check" "kubernetes-api" {
  name               = "kubernetes-api"
  request_path       = "/healthz"
  host               = "kubernetes.default.svc.cluster.local"
}

resource "google_compute_http_health_check" "application" {
  name               = "application"
  request_path       = "/healthz"
  port               = 80
}

resource "google_compute_firewall" "kubernetes-the-hard-way-allow-health-check" {
  name    = "kubernetes-the-hard-way-allow-health-check"
  network = "${var.network-link}"

  allow {
    protocol = "tcp"
  }

  source_ranges = [ "209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16","130.211.0.0/22" ]
}

resource "google_compute_target_pool" "kubernetes-target-pool-api" {
  name = "kubernetes-target-pool-api"

  health_checks = [
    "${google_compute_http_health_check.kubernetes-api.self_link}",
  ]

  instances = [ "${var.pool_instances}" ]

}

resource "google_compute_target_pool" "kubernetes-target-pool-application" {
  name = "kubernetes-target-pool-application"

  health_checks = [
    "${google_compute_http_health_check.application.self_link}",
  ]

  instances = [ "${var.pool_instances_application}" ]

}

resource "google_compute_forwarding_rule" "kubernetes-forwarding-rule-api" {
  name       = "kubernetes-forwarding-rule-api"
  target     = "${google_compute_target_pool.kubernetes-target-pool-api.self_link}"
  port_range = "6443"
  region     = "${var.region}"
  ip_address = "${var.external_ip}"
}


resource "google_compute_forwarding_rule" "kubernetes-forwarding-rule-application" {
  name       = "kubernetes-forwarding-rule-application"
  target     = "${google_compute_target_pool.kubernetes-target-pool-application.self_link}"
  port_range = "80"
  region     = "${var.region}"
}


