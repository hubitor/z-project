provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

terraform {
  backend "gcs" {
    bucket = "remote_bucket"
    prefix = "terraform/state"
  }
}

module "network" {
  instance_count           = "${var.w_count}"
  source                   = "../modules/network"
  region		   = "${var.region}"
  subnetwork_name          = "${var.subnetwork_name}"
}

module "controller" {
  instance_count           = "${var.c_count}"
  source                   = "../modules/controller"
  public_key_path          = "${var.public_key_path}"
  name                     = "${var.cluster_name}-${var.controller_name}"
  zone                     = "${var.zone}"
  controller_disk_image    = "${var.controller_disk_image}"
  tags                     = ["kubernetes-the-hard-way", "controller", "${var.cluster_name}-controller"]
  ssh_key_for_provisioners = "${var.ssh_key_for_provisioners}"
  subnet		   = "${module.network.kubernetes_subnet_name}"
  address                  = "${module.network.kubernetes_subnet_range}"
}

module "worker" {
  instance_count           = "${var.w_count}"
  source                   = "../modules/worker"
  public_key_path          = "${var.public_key_path}"
  name                     = "${var.cluster_name}-${var.worker_name}"
  zone                     = "${var.zone}"
  worker_disk_image        = "${var.worker_disk_image}"
  tags                     = ["kubernetes-the-hard-way", "worker", "${var.cluster_name}-worker", "http-server"]
  ssh_key_for_provisioners = "${var.ssh_key_for_provisioners}"
  subnet		   = "${module.network.kubernetes_subnet_name}"
  address                  = "${module.network.kubernetes_subnet_range}"
  pods_range               = "${module.network.pods_subnet_range}"

}

module "nfs" {
  source                   = "../modules/nfs-server"
  public_key_path          = "${var.public_key_path}"
  name                     = "${var.cluster_name}-nfs"
  zone                     = "${var.zone}"
  nfs_disk_image           = "${var.nfs_disk_image}"
  disk_size                = 50
  tags                     = ["kubernetes-the-hard-way", "nfs", "nfs-server"]
  ssh_key_for_provisioners = "${var.ssh_key_for_provisioners}"
  subnet		   = "${module.network.kubernetes_subnet_name}"
  address                  = "${module.network.kubernetes_subnet_range}"

}

module "load-balancer" {
  source                   = "../modules/load-balancer"
  region                   = "${var.region}"
  pool_instances           = "${module.controller.controller_links}"
  pool_instances_application           = "${module.worker.worker_links}"
  network-link             = "${module.network.network-link}"
  subnet		   = "${module.network.kubernetes_subnet_name}"
  external_ip              = "${module.network.external_ip}"
}

