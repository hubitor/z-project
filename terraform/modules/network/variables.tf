variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable network_name {
  description = "Network name"
  default     = "kubernetes-the-hard-way"
}

variable subnetwork_name {
  description = "Subnetwork name"
}

variable region {
  description = "Network region"
}

variable instance_count {
  description = "Instance count"
}

variable kubernetes_ip_range {
  description = "IP range for Kubernetes subnetwork"
  default     = "10.240.0.0/24"
}

variable pods_ip_range {
  description = "IP range for Kubernetes pods subnetwork"
  default     = "10.200.0.0/16"
}

