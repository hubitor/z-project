variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable controller_disk_image {
  description = "Disk image for a controller host"
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

variable subnet {
  description = "Default subnet name for a controller host"
}

variable address {
  description = "A network address for a controller host"
}

variable name {
  description = "An instance name"
  default     = "controller"
}

variable tags {
  description = "k8s-controller"
  type        = "list"
}

variable ssh_key_for_provisioners {
  description = "Path to ssh private key for provisioners"
}

variable instance_count {
  description = "Number of instances to run"
  default     = "1"
}

