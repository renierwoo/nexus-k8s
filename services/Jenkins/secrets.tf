resource "kubernetes_secret_v1" "jenkins_controller_ingress" {
  metadata {
    name      = "jenkins-controller-ingress"
    namespace = var.jenkins_controller_release_namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.key" = var.domain_tls_key
    "tls.crt" = var.domain_tls_crt
  }
}
