output "nfs_ip" {
  value = "${join(", ",google_compute_instance.nfs.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}

