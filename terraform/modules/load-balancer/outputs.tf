output "application_load-balaner_ip" {
  value = "${google_compute_forwarding_rule.kubernetes-forwarding-rule-application.ip_address}"
}
