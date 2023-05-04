resource "helm_release" "jenkins_controller" {
  name        = var.jenkins_controller_release_name
  repository  = var.jenkins_controller_repository
  chart       = var.jenkins_controller_chart
  version     = var.jenkins_controller_chart_version
  namespace   = var.jenkins_controller_release_namespace
  description = "Jenkins Continuous Integration Platform"

  set {
    name  = "controller.tag"
    value = var.jenkins_controller_image_tag
  }

  set {
    name  = "nameOverride"
    value = var.jenkins_controller_chart
  }

  set {
    name  = "fullnameOverride"
    value = var.jenkins_controller_release_name
  }

  set {
    name  = "namespaceOverride"
    value = var.jenkins_controller_release_namespace
  }

  set {
    name  = "controller.adminUser"
    value = var.jenkins_controller_admin_user
  }

  set {
    name  = "controller.adminPassword"
    value = var.jenkins_controller_admin_password
  }

  # set {
  #   name  = "controller.serviceExternalTrafficPolicy"
  #   value = "Local"
  # }

  set {
    name  = "controller.ingress.enabled"
    value = "true"
  }

  set {
    name  = "controller.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "controller.ingress.path"
    value = "/"
  }

  set {
    name  = "controller.ingress.hostName"
    value = var.jenkins_controller_domain
  }

  values = [
    templatefile("${path.module}/artifacts/values.yaml", {
      domain = var.domain
      secretName = kubernetes_secret_v1.jenkins_controller_ingress.metadata.0.name
    })
  ]

  set {
    name  = "persistence.storageClass"
    value = kubernetes_storage_class_v1.jenkins_controller.metadata.0.name
  }

  set {
    name  = "persistence.size"
    value = "10Gi"
  }

  depends_on = [
    kubernetes_secret_v1.jenkins_controller_ingress,
    kubernetes_storage_class_v1.jenkins_controller
  ]
}
