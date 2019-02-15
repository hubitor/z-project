variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable region {
  description = "Network region"
}

variable network-link {
  description = "Kubernetes network link"
}

variable external_ip {
  description = "Static global IP"
}

variable pool_instances {
  description = "Pool of GCE instances (controllers)"
  type        = "list"
}

variable pool_instances_application {
  description = "Pool of GCE instances (workers)"
  type        = "list"
}

