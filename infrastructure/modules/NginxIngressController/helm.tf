resource "helm_release" "nginx_ingress_controller" {
  name        = var.nginx_ic_release_name
  repository  = var.nginx_ic_repository
  chart       = var.nginx_ic_chart
  version     = var.nginx_ic_chart_version
  namespace   = var.nginx_ic_release_namespace
  description = "Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer"

  set {
    name  = "nameOverride"
    value = var.nginx_ic_name_override
  }

  set {
    name  = "fullnameOverride"
    value = var.nginx_ic_name_override
  }

  set {
    name  = "controller.kind"
    value = var.nginx_ic_controller_kind
  }

  set {
    name  = "controller.image.tag"
    value = var.nginx_ic_controller_image_tag
  }

  set {
    name  = "controller.replicaCount"
    value = var.nginx_ic_controller_replicaCount
  }

  set {
    name  = "controller.terminationGracePeriodSeconds"
    value = var.nginx_ic_controller_terminationGracePeriodSeconds
  }

  set {
    name  = "controller.externalTrafficPolicy"
    value = "Local"
  }

  # values = [
  #   {
  #     name      = "csp-nonce"
  #     mountPath = "/var/run/secrets/csp-nonce"
  #     secret    = {
  #       secretName = kubernetes_secret.csp_nonce_secret.metadata[0].name
  #       items = [
  #         {
  #           key  = "csp-nonce.pem"
  #           path = "csp-nonce.pem"
  #         }
  #       ]
  #     }
  #   }
  # ]

  # set {
  #   name  = "values"
  #   value = jsonencode([
  #     {
  #       name      = "csp-nonce"
  #       mountPath = "/var/run/secrets/csp-nonce"
  #       secret    = {
  #         secretName = kubernetes_secret.csp_nonce_secret.metadata[0].name
  #         items = [
  #           {
  #             key  = "csp-nonce.pem"
  #             path = "csp-nonce.pem"
  #           }
  #         ]
  #       }
  #     }
  #   ])
  # }

  # set {
  #   name  = "controller.config.proxy-set-headers"
  #   value = "{'Content-Security-Policy': \"$(cat /var/run/secrets/csp-nonce/key.pem | openssl dgst -sha256 -binary | openssl enc -base64 | tr '+/' '-_')\"}"
  # }

  # set {
  #   name  = "controller.enableLatencyMetrics"
  #   value = var.nginx_ic_controller_enableLatencyMetrics
  # }

  # set {
  #   name  = "prometheus.create"
  #   value = var.nginx_ic_prometheus_create
  # }

  # set {
  #   name  = "prometheus.port"
  #   value = var.nginx_ic_prometheus_port
  # }

  # set {
  #   name  = "prometheus.scheme"
  #   value = var.nginx_ic_prometheus_scheme
  # }
}