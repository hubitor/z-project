output "controller_ip" {
  value = "${join(", ",google_compute_instance.controller.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}

output "controller_links" {
  value = [ "${google_compute_instance.controller.*.self_link}" ]
}
