variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable nfs_disk_image {
  description = "Disk image for a NFS host"
  default     = "ubuntu-1804-bionic-v20181222"
}

variable disk_size {
  description = "Disk size"
  default     = 50
}

variable public_key_path {
  description = "Path to the public key for ssh"
}

variable subnet {
  description = "Default subnet name for a worker host"
}

variable address {
  description = "A network address for a worker host"
}

variable name {
  description = "An instance name"
  default     = "nfs"
}

variable tags {
  description = "nfs-server"
  type        = "list"
}

variable ssh_key_for_provisioners {
  description = "Path to ssh private key for provisioners"
}

