variable project {
  description = "Project ID"
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

variable disk_image {
  description = "Diks image"
}

variable ssh_key_for_provisioners {
  description = "SSH private key for provisioners"
}

