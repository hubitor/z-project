output "controller_external_ips" {
  value = "${module.controller.controller_ip}"
}

output "worker_external_ips" {
  value = "${module.worker.worker_ip}"
}

output "nfs_external_ips" {
  value = "${module.nfs.nfs_ip}"
}
