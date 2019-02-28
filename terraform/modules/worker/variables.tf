variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable worker_disk_image {
  description = "Disk image for a worker host"
  default     = "ubuntu-1804-bionic-v20181222"
}

variable public_key_path {
  description = "Path to the public key for ssh"
}

variable depends_on {
  description = "Depends_on emulation for Terraform"
  default     = []
  type        = "list"
}

variable worker-disk-links {
  description = "List of self_links of disks for workers"
  default     = []
  type        = "list"
}

variable subnet {
  description = "Default subnet name for a worker host"
}

variable address {
  description = "A network address for a worker host"
}

variable pods_range {
  description = "A network for pods"
}

variable name {
  description = "An instance name"
  default     = "worker"
}

variable tags {
  description = "k8s-worker"
  type        = "list"
}

variable ssh_key_for_provisioners {
  description = "Path to ssh private key for provisioners"
}

variable instance_count {
  description = "Number of instances to run"
  default     = "1"
}

