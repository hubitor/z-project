variable disk_image {
  description = "Disk image for nodes"
  default     = "ubuntu-1804-bionic-v20181222"
}

variable project {
  description = "Project ID"
}

variable cluster_name {
  description = "A cluster name"
  default = "z-project"
}

variable controller_name {
  description = "A Controller node name"
  default = "controller"
}

variable worker_name {
  description = "A Work node name"
  default = "worker"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key for ssh"
}

variable subnetwork_name {
  description = "Subnetwork name for k8s hosts"
  default     = "kubernetes"
}

variable ssh_key_for_provisioners {
  description = "SSH private key for provisioners"
}

variable controller_disk_image {
  description = "An image for a controller host"
  default     = "ubuntu-1804-bionic-v20181222"
}

variable worker_disk_image {
  description = "An image for a worker host"
  default     = "ubuntu-1804-bionic-v20181222"
}

variable nfs_disk_image {
  description = "An image for a NFS host"
  default     = "ubuntu-1804-bionic-v20181222"
}

variable w_count {
  description = "Number of worker instances to run"
  default     = "3"
}

variable c_count {
  description = "Number of controller instances to run"
  default     = "3"
}
