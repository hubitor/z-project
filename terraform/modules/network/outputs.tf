output "kubernetes_subnet_range" {
  value = "${google_compute_subnetwork.kubernetes.ip_cidr_range}"
}

output "kubernetes_subnet_name" {
  value = "${google_compute_subnetwork.kubernetes.self_link}"
}

output "pods_subnet_range" {
  value = "${var.pods_ip_range}"
}

output "network-link" {
  value = "${google_compute_network.kubernetes-the-hard-way.self_link}"
}

output "external_ip" {
  value = "${google_compute_address.kubernetes-the-hard-way.address}"
}
